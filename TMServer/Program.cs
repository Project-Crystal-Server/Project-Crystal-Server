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

using Crystal.Common.MiniGame;
using Crystal.Common.PolFileSystem;
using NLog;
using System;
using System.IO;
using System.Text;
using System.Threading;

namespace Crystal.TetraMaster
{
    class Program
    {
        public static readonly Logger Log = LogManager.GetCurrentClassLogger();

        private static TmBalancerServer BalancerServer;
        private static TmShopMenuServer ShopMenuServer;

        static void Main(string[] args)
        {
            // Setup Base DIR
            string baseDir = Path.GetDirectoryName(Environment.ProcessPath) ?? AppContext.BaseDirectory;
            Directory.SetCurrentDirectory(baseDir);
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

            // Load NLog Config
            using var nlogStream = typeof(Program).Assembly.GetManifestResourceStream("Crystal.TetraMaster.NLog.config");
            using var nlogReader = new StreamReader(nlogStream);
            LogManager.Configuration = new NLog.Config.XmlLoggingConfiguration(nlogReader, null);

            Log.Info("===================");
            Log.Info("Tetra Master Server");
            Log.Info("===================");

            Mg.Init("TM0");

            // Config Load
            TetraMasterConfig config = LoadConfig(args);
            if (config == null)
                return;
            PolFileSys.Init(config.ProfileDir);

            // Args
            ProcessArgs(args, out bool startBalancer, out bool startShopMenuServer);

            startBalancer = startShopMenuServer = true;

            // Start the servers. Requires a POLAuth instance running in minigame mode.
            if (startBalancer)
            {
                BalancerServer = new TmBalancerServer();
                BalancerServer.StartServer();
            }

            if (startShopMenuServer)
            {
                ShopMenuServer = new TmShopMenuServer(TmConstants.SHOPMENU_POLID, TmConstants.SHOPMENU_DOMAIN, TmConstants.SHOPMENU_VOLUME);
                ShopMenuServer.StartServer();
            }

            // Command line loop
            while (true)
            {
                string command = Console.ReadLine();
                if (command.StartsWith("test"))
                {
                    ShopMenuServer?.Test();
                }
                else if (command.Equals("clear"))
                    Console.Clear();

                Thread.Sleep(500);
            }
        }

        static TetraMasterConfig LoadConfig(string[] args)
        {
            // Get path if exists
            string cfgPath = "./tm.cfg";
            for (int i = 0; i < args.Length; i++)
            {
                if (args[i].ToLower().Equals("--config") && args.Length > i + 1)
                {
                    cfgPath = args[i + 1];
                    break; 
                }
            }

            // Load and perform checks for mandatory fields
            TetraMasterConfig config;
            try
            {
                config = new(cfgPath);
            }
            catch (Exception e)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Log.Error($"Could not load the config: {e.Message}");
                Console.ForegroundColor = ConsoleColor.Gray;
                return null;
            }

            if (config.ProfileDir == null)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Log.Error("Config: Profile directory was not set.");
                Console.ForegroundColor = ConsoleColor.Gray;
                return null;
            }

            return config;
        }

        private static void ProcessArgs(string[] args, out bool startBalancer, out bool startShopMenuServer)
        {
            // Default
            if (args.Length == 0)
                startBalancer = startShopMenuServer = true;
            else
                startBalancer = startShopMenuServer = false;

            // Find args
            for (int i = 0; i < args.Length; i++)
            {
                switch (args[i])
                {
                    case "--balancer":
                        startBalancer = true;
                        break;
                    case "--shopmenu":
                        startShopMenuServer = true;
                        break;
                }
            }
        }
    }
}
