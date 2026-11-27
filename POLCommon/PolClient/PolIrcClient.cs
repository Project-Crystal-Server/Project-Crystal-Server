/*
===========================================================================
Copyright (C) 2019-2026 Project Crystal Dev Team

This file is part of Project Crystal Server.

Project Crystal Server is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Project Crystal Server is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Project Crystal Server. If not, see <https://www.gnu.org/licenses/>.
===========================================================================
*/

using NLog;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Crystal.Common.PolClient
{
    /*
     * Bot client for a POL-Auth IRC server. Logs in through the "BotBotBot" path, then relays
     * server messages (and optionally NOTICEs from other users) to a callback.
    */
    public class PolIrcClient
    {
        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        private readonly string Name;
        private readonly string PolId;
        private readonly string Password;
        private readonly bool ScrambleAsBot;
        private readonly bool DeliverNotices;

        private Socket ClientSocket;
        private readonly byte[] ReceiveBuffer = new byte[0xFFFF];
        private int ReceivePartialSize = 0;
        private readonly object SendLock = new();
        public SqCrypto CurrentCrypto;
        private SqRSAKeyPair RsaKeys;
        private string InitInfoBase32;

        private volatile bool isConnected = false;
        private volatile bool isAdminData = false;
        private volatile bool isCryptoReady = false;
        private volatile bool isAuthenticated = false;
        private volatile bool AuthError = false;

        private readonly Action<string, string> ReceiveMsgCallback;
        private Action<string> JoinChannelCallback = null;
        private string CurrentChannel = null;

        // Server messages only, passed as the message text. Logs in with a bot ('P') nick.
        public PolIrcClient(string name, string polId, string password, Action<string> receiveMsgCallback = null)
        {
            Name = name;
            PolId = polId;
            Password = password ?? "";
            ReceiveMsgCallback = receiveMsgCallback == null ? null : (_, message) => receiveMsgCallback(message);
            ScrambleAsBot = true;
            DeliverNotices = false;
        }

        // Server messages and NOTICEs, passed as (source POL ID, message). Logs in with a user ('U') nick.
        public PolIrcClient(string name, ulong polId, Action<string, string> receiveMsgCallback, string password = "")
            : this(name, SqCrypto.PolIdToPolProData(polId), password)
        {
            ReceiveMsgCallback = receiveMsgCallback;
            ScrambleAsBot = false;
            DeliverNotices = true;
        }

        public bool Connect(string host, int port)
        {
            AuthError = false;
            isAdminData = isCryptoReady = isAuthenticated = false;
            CurrentCrypto = null;
            ReceivePartialSize = 0;

            try
            {
                if (!IPAddress.TryParse(host, out IPAddress address))
                    address = Dns.GetHostEntry(host).AddressList[0];

                ClientSocket = new Socket(address.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
                ClientSocket.Connect(new IPEndPoint(address, port));
            }
            catch (Exception e)
            {
                isConnected = false;
                Log.Debug($"[{Name}] - could not connect to POL-Auth at {host}:{port}: {e.Message}");
                return false;
            }

            isConnected = true;
            Log.Debug($"[{Name}] - connected to POL-Auth at {host}:{port}");
            BeginReceive();
            return true;
        }

        // Blocks until authenticated, retrying so the POL-Auth server can be started in any order
        public void ConnectAndAuthenticate(string host, int port, int retryDelayMs = 5000)
        {
            while (true)
            {
                if (Connect(host, port) && WaitAuthentication(10000))
                    return;

                if (isConnected)
                    Disconnect(sendQuit: false);
                Log.Warn($"[{Name}] - could not authenticate with POL-Auth at {host}:{port}, retrying in {retryDelayMs / 1000}s...");
                Thread.Sleep(retryDelayMs);
            }
        }

        public bool WaitAuthentication(int timeoutMS)
        {
            var sw = System.Diagnostics.Stopwatch.StartNew();
            while (!IsAuthenticated())
            {
                if (AuthenticationFailed() || !isConnected || sw.ElapsedMilliseconds >= timeoutMS)
                    return false;
                Thread.Sleep(50);
            }

            return true;
        }

        public void Disconnect(bool sendQuit = true)
        {
            if (sendQuit && isConnected)
                SendLine("QUIT", disconnectOnError: false);

            isConnected = isCryptoReady = isAuthenticated = isAdminData = false;
            CurrentCrypto = null;
            ClientSocket?.Close();
        }

        public bool IsConnected() => isConnected;

        public bool IsCryptoReady() => isCryptoReady;

        public bool IsAuthenticated() => isAuthenticated;

        public bool AuthenticationFailed() => AuthError;

        public string GetCurrentChannel() => CurrentChannel;

        public uint GetMyIp()
        {
            if (ClientSocket == null || !ClientSocket.Connected)
                return 0xFFFFFFFF;
            var clientConnection = (IPEndPoint)ClientSocket.LocalEndPoint;
            return Utils.SwapEndian(BitConverter.ToUInt32(clientConnection.Address.GetAddressBytes()));
        }

        public uint GetMyPort()
        {
            if (ClientSocket == null || !ClientSocket.Connected)
                return 0xFFFFFFFF;
            var clientConnection = (IPEndPoint)ClientSocket.LocalEndPoint;
            return (uint)clientConnection.Port;
        }

        public bool JoinChannel(string channelName, Action<string> callback)
        {
            if (JoinChannelCallback != null)
                return false;

            JoinChannelCallback = callback;
            SendLine($"JOIN {channelName}");
            return true;
        }

        public void Notice(string target, string message)
        {
            SendLine($"NOTICE {SqCrypto.ScramblePolId(target)} :{message}");
        }

        private void SendLine(string message, bool encryptMessage = true, bool disconnectOnError = true)
        {
            string checksum = SqCrypto.CheckSumToStr(SqCrypto.CalcCheckSum(message));
            byte[] result = Encoding.ASCII.GetBytes($"{message}{checksum}\r\n");

            bool failed = false;
            lock (SendLock)
            {
                SqCrypto crypto = CurrentCrypto;
                if (encryptMessage && crypto != null)
                    crypto.SqCrypt64(result, result.Length, 1);

                try
                {
                    ClientSocket.Send(result);
                }
                catch (Exception)
                {
                    failed = true;
                }
            }

            if (failed && disconnectOnError)
                Disconnect(sendQuit: false);
        }

        #region Crypto

        private void StartHandshake()
        {
            RsaKeys = SqCrypto.RSAGenerate();
            Log.Debug($"[{Name}] - POL-Auth handshake started");
            byte[] modulus = RsaKeys.Public.Modulus.ToByteArrayUnsigned();
            Array.Reverse(modulus);
            string rsaB32 = SqCrypto.EncodeBase64(modulus, modulus.Length, true);
            SendLine($"USER x 8 * :{rsaB32}");
        }

        private void InitCrypto(string serverMsg)
        {
            byte[] result = SqCrypto.DecodeBase64(serverMsg, serverMsg.Length);
            byte[] cleanedResult = new byte[32];
            Array.Copy(result, cleanedResult, 32);

            byte[] blowfishKey = SqCrypto.RSADecrypt(RsaKeys.Private, cleanedResult);
            byte[] modulus = RsaKeys.Public.Modulus.ToByteArrayUnsigned();
            Array.Reverse(modulus);
            Array.Reverse(blowfishKey);
            CurrentCrypto = new SqCrypto(blowfishKey, modulus);
            isCryptoReady = true;

            string passwordMD5 = SqCrypto.GeneratePOLPasswordMD5(InitInfoBase32, Encoding.ASCII.GetBytes(Password));

            SendLine($"NICK :{SqCrypto.ScramblePolId(PolId, ScrambleAsBot)}:{passwordMD5}:BotBotBot");
        }

        private void WelcomeConfirm(string msg)
        {
            if (msg.Equals("Gucci"))
            {
                isAuthenticated = true;
                Log.Info($"[{Name}] - POL-Auth handshake complete");
            }
            else
            {
                isAuthenticated = false;
                AuthError = true;
                Log.Warn($"[{Name}] - POL-Auth handshake failed");
                Disconnect(sendQuit: false);
            }
        }
        #endregion

        #region Sockets

        private void BeginReceive()
        {
            try
            {
                ClientSocket.BeginReceive(ReceiveBuffer, ReceivePartialSize, ReceiveBuffer.Length - ReceivePartialSize, SocketFlags.None, new AsyncCallback(ReceiveCallback), null);
            }
            catch (Exception)
            {
                Disconnect(sendQuit: false);
            }
        }

        private void ReceiveCallback(IAsyncResult result)
        {
            int bytesRead;
            try
            {
                bytesRead = ClientSocket.EndReceive(result);
            }
            catch (Exception)
            {
                Disconnect(sendQuit: false);
                return;
            }

            if (bytesRead == 0)
            {
                Log.Debug($"[{Name}] - POL-Auth closed the connection");
                Disconnect(sendQuit: false);
                return;
            }

            // Each line is encrypted on its own and the crypto leaves CR/LF untouched, so split
            // on LF first and decrypt line by line.
            Span<byte> data = ReceiveBuffer.AsSpan(0, ReceivePartialSize + bytesRead);
            int length;
            while ((length = data.IndexOf((byte)'\n') + 1) > 0)
            {
                Span<byte> line = data[..length];
                if (isCryptoReady)
                    CurrentCrypto.SqCrypt64(line, length, 1);

                string message = Encoding.ASCII.GetString(line).TrimEnd('\r', '\n');
                try
                {
                    ProcessLine(message);
                }
                catch (Exception e)
                {
                    Log.Error($"[{Name}] - error handling line \"{message}\":\n{e}");
                }

                data = data[length..];
            }

            // Keep any partial line (still encrypted) for the next read
            if (data.Length == ReceiveBuffer.Length)
            {
                Log.Warn($"[{Name}] - receive buffer full without a line break, dropping it");
                data = Span<byte>.Empty;
            }
            data.CopyTo(ReceiveBuffer);
            ReceivePartialSize = data.Length;

            if (isConnected)
                BeginReceive();
        }

        private void ProcessLine(string line)
        {
            if (line.Length < 5)
                return;

            // Split the message and checksum
            string message = line[..^4];
            string checksum = line[^4..];

            // Verify Checksum
            string ourChecksum = SqCrypto.CheckSumToStr(SqCrypto.CalcCheckSum(message));
            if (!ourChecksum.Equals(checksum))
                Log.Debug($"[{Name}] - received invalid checksum!");

            // Handle Msg
            if (message[0] == ':')
            {
                string[] colonSplit = message.Split(':');
                string[] firstPartSplit = colonSplit[1].Split(' ');
                if (firstPartSplit.Length < 2)
                    return;

                string source = firstPartSplit[0];
                string command = firstPartSplit[1];
                if (int.TryParse(command, out int replyCode))
                {
                    switch (replyCode)
                    {
                        case 001:
                            if (firstPartSplit.Length >= 3)
                                WelcomeConfirm(firstPartSplit[2]);
                            break;
                        case 300:
                            if (firstPartSplit.Length < 4)
                                break;

                            if (isAuthenticated)
                            {
                                ReceiveMsgCallback?.Invoke(source, message[message.LastIndexOf(firstPartSplit[3])..]);
                            }
                            else if (!isAdminData)
                            {
                                isAdminData = true;
                                InitInfoBase32 = firstPartSplit[3];
                                StartHandshake();
                            }
                            else
                                InitCrypto(firstPartSplit[3]);
                            break;
                    }
                }
                else if (command.Equals("NOTICE"))
                {
                    if (DeliverNotices && source.Length >= 9 && colonSplit.Length == 3)
                        ReceiveMsgCallback?.Invoke(SqCrypto.UnScramblePolId(source[..9]), colonSplit[2]);
                }
                else if (command.Equals("JOIN") && firstPartSplit.Length == 3)
                {
                    string channelName = firstPartSplit[2];
                    JoinChannelCallback?.Invoke(channelName);
                    JoinChannelCallback = null;
                    CurrentChannel = channelName;
                }
            }
            else
            {
                string[] colonSplit = message.Split(':');
                if (colonSplit.Length >= 2 && colonSplit[0].Trim().Equals("PING"))
                    SendLine($"PONG :{colonSplit[1]}");
            }
        }
        #endregion
    }
}
