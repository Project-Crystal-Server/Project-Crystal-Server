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

using System;
using System.Runtime.InteropServices;
using System.Text;

namespace Crystal.POLProfile.DataObjects.Pol.Character
{
    [StructLayout(LayoutKind.Explicit, Size = SIZE)]
    unsafe struct SearchPolIdResult
    {
        [FieldOffset(0x00)] public ulong PolId;
        [FieldOffset(0x10)] private fixed byte HandleNameBuff[0x10];
        [FieldOffset(0x20)] public byte Found;
        [FieldOffset(0x21)] public byte HandleNum;

        public const int SIZE = 0x30;

        public string Name
        {
            get
            {
                fixed (byte* ptr = &HandleNameBuff[0])
                {
                    string str = Encoding.UTF8.GetString(new ReadOnlySpan<byte>(ptr, 0x10));
                    return str[..str.IndexOf('\0')];
                }
            }

            set
            {
                ReadOnlySpan<byte> name = Encoding.UTF8.GetBytes(value);
                int len = name.Length <= 0x10 ? name.Length : 0x10;
                fixed (byte* pName = &HandleNameBuff[0])
                {
                    name.CopyTo(new Span<byte>(pName, len));
                }
            }
        }
    }
}