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

using Crystal.Common;
using Crystal.POLProfile.DataObjects.Pol.Character;
using MySqlConnector;
using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text;

namespace Crystal.POLProfile.DataObjects.Pol.Friend
{
    [StructLayout(LayoutKind.Explicit)]
    public unsafe struct FriendData
    {
        [FieldOffset(0x00)] public ulong Bitfield;
        [FieldOffset(0x08)] public byte CreationPosition;
        [FieldOffset(0x09)] public byte CustomPosition;
        [FieldOffset(0x0A)] public byte UnknownPosition;
        [FieldOffset(0x10)] public ulong PolProId;
        [FieldOffset(0x18)] private fixed byte NameBuff[0x10];
        [FieldOffset(0x28)] public CharacterPrimitive CharacterPrimitive1;
        [FieldOffset(0x38)] public CharacterPrimitive CharacterPrimitive2;
        [FieldOffset(0x48)] public CharacterPrimitive CharacterPrimitive3;
        [FieldOffset(0x58)] public CharacterPrimitive CharacterPrimitive4;
        [FieldOffset(0x68)] public CharacterPrimitive CharacterPrimitive5;
        [FieldOffset(0x78)] public CharacterPrimitive CharacterPrimitive6;
        [FieldOffset(0x88)] public CharacterPrimitive CharacterPrimitive7;
        [FieldOffset(0x98)] public CharacterPrimitive CharacterPrimitive8;

        public const int SIZE = 0xA8;

        public bool IsValid
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => (Bitfield & 1) == 1;

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set
            {
                Bitfield = value ? Bitfield | 1 : Bitfield & ~((ulong)1);
            }
        }

        public bool IsBlackList
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => (Bitfield >> 4 & 1) == 1;

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set
            {
                Bitfield = value ? (Bitfield | 0x10) : (Bitfield & 0xFFFFFFFFFFFFFFEF);
            }
        }

        public bool IsFriendList
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => !IsBlackList;

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set => IsBlackList = !IsBlackList;
        }

        public byte Level
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => (byte)((Bitfield >> 5) & 0x3);

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set
            {
                Bitfield = Bitfield & 0xFFFFFFFFFFFFFF1F | (((ulong)value & 0x3) << 5);
            }
        }

        public byte HandlePosition
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => (byte)((Bitfield >> 7) & 0x3F);

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set
            {
                Bitfield = Bitfield & 0xFFFFFFFFFFFFE07F | (((ulong)value & 0x3F) << 7);
            }
        }

        public ulong HandleId
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => ((Bitfield >> 0xD) & 0x3FFFFFFFFF);

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set
            {
                Bitfield = Bitfield & 0xFFF8000000001FFF | ((value & 0x3FFFFFFFFF) << 0xD);
            }
        }

        public byte Group
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => (byte)((Bitfield >> 0x39) & 0xF);

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set 
            {
                Bitfield = Bitfield & 0xE1FFFFFFFFFFFFFF | (((ulong)value & 0xF) << 0x39);
            }
        }

        public bool Temporary 
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => (Bitfield >> 62 & 1) == 1;

            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            set 
            { 
                Bitfield = value ? (Bitfield | 0x4000000000000000) : (Bitfield & 0xBFFFFFFFFFFFFFFF); 
            }
        }

        public string Name
        {
            get
            {
                fixed (byte* ptr = &NameBuff[0])
                {
                    string str = Encoding.ASCII.GetString(new ReadOnlySpan<byte>(ptr, 0xF));
                    return str[..(str.Contains('\0') ? str.IndexOf('\0') : str.Length)];
                }
            }

            set
            {
                ReadOnlySpan<byte> name = Encoding.ASCII.GetBytes(value);
                int len = name.Length <= 0xF ? name.Length : 0xF;
                fixed (byte* pName = &NameBuff[0])
                {
                    name.CopyTo(new Span<byte>(pName, len));
                }
            }
        }

        public string PolProData
        {
            get => SqCrypto.PolIdToPolProData(PolProId);
        }

        public static FriendData FromSql(MySqlDataReader reader)
        {
            ulong polProId = SqCrypto.PolProDataToPolId(reader.GetString("polProId"), 0, 0);
            ulong handleId = reader.GetUInt64("handleId");
            byte handlePosition = reader.GetByte("handlePosition");
            byte level = reader.GetByte("level");
            string name = reader.GetString("name");
            byte creationPosition = reader.GetByte("creationPosition");
            byte customPosition = reader.GetByte("customPosition");
            byte group = reader.GetByte("grp");
            bool isTemp = reader.GetBoolean("temp");
            bool isBlacklist = reader.GetBoolean("blacklist");

            FriendData friendData = new()
            {
                IsValid = true,
                IsBlackList = isBlacklist,
                Level = level,
                HandlePosition = handlePosition,
                HandleId = handleId,
                Group = group,
                Temporary = isTemp,
                CreationPosition = creationPosition,
                CustomPosition = customPosition,
                PolProId = polProId,
                Name = name
            };

            return friendData;
        }

        public void SetCharacterPrimitives(List<CharacterPrimitive> prims)
        {
            Span<CharacterPrimitive> slots = MemoryMarshal.CreateSpan(ref CharacterPrimitive1, 8);
            slots.Clear();
            for (int i = 0; i < prims.Count && i < slots.Length; i++)
                slots[i] = prims[i];
        }

        public override string ToString()
        {
            string isValid = IsValid ? "O" : "X";
            return $"[{isValid}] Pos:{CreationPosition},{CustomPosition}, FL: {IsFriendList}, HandleId: {HandleId}, IsTemp:{(Temporary ? "Y" : "N")}, Name: {Name}";
        }

        public static FriendData CreateStranger(ulong polProId, ulong handleId, byte handleNum, string name, List<CharacterPrimitive> prims)
        {
            FriendData friendData = new()
            {
                IsValid = true,
                IsBlackList = false,
                Level = 1,
                HandlePosition = handleNum,
                HandleId = handleId,
                Group = 0,
                Temporary = false,
                CreationPosition = 0,
                CustomPosition = 0,
                PolProId = polProId,
                Name = name
            };
            friendData.SetCharacterPrimitives(prims);

            return friendData;
        }
    }
}
