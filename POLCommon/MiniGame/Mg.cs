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

using System.Text;

namespace Crystal.Common.MiniGame
{
    public class Mg
    {
        internal static string GameCode = "@@@";
        private static bool IsInitialized = false;

        public static Encoding Encoding = Encoding.GetEncoding("Shift_JIS");

        public static void Init(string gameCode)
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            GameCode = gameCode;
            IsInitialized = true;
        }

        // Converts between a real POL ID and the form the game client uses, with the crypt key of the game
        // set with Init ("TM0" is TmKey). The key is an XOR, so the same call converts both ways. 0 (no ID)
        // is left as is, as is any ID when Init was never called.
        public static ulong CryptPolId(ulong polId)
        {
            if (!IsInitialized || polId == 0)
                return polId;

            uint gameCode = (uint)(GameCode[0] | GameCode[1] << 8 | GameCode[2] << 16);
            return ChangeCryptKey(polId, gameCode);
        }

        public static ulong MjKey(ulong polId)
        {
            return ChangeCryptKey(polId, 0x00534A4DU); //MJS
        }

        public static ulong TmKey(ulong polId)
        {
            return ChangeCryptKey(polId, 0x00304D54U); //TM0
        }

        private static ulong ChangeCryptKey(ulong polId, uint gamecode) {
            uint gamecodeMultiply = unchecked(gamecode * gamecode);
            uint calc = unchecked(gamecodeMultiply << 9);
            calc = unchecked(calc + gamecodeMultiply);
            calc = unchecked(4 * (4 * calc + calc) + gamecodeMultiply);
            calc += 2 * calc;
            calc += 4 * calc;
            calc = unchecked(calc << 7);
            calc += gamecodeMultiply;

            ulong crypt1 = calc;
            ulong crypt2 = unchecked(gamecode * gamecode * 0x12cc4f5U);
            ulong crypt = (crypt2 << 32) | crypt1;

            return SqCrypto.ChangeCryptPolId(polId, 0, crypt);
        }
    }
}
