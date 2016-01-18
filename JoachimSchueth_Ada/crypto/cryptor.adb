------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Command_Line;
use  Ada.Command_Line;
with SZ42, SZ42.Text_IO;

procedure Cryptor is
    Pat: SZ42.Wheel_Patterns;
    Pos: SZ42.Wheel_Positions;
    Lim: SZ42.Limitation_T;
    Machine: SZ42.Machine;

    type Symbol_Buffer_T is access SZ42.Symbol_String;

    Text: Symbol_Buffer_T := new SZ42.Symbol_String(1..20000);
    Len: Natural;
begin
    SZ42.Text_IO.Read_Key(Argument(1), Pat, Pos, Lim);
    SZ42.Init_Machine(Machine, Pat, Pos, Lim);
    SZ42.Text_IO.Read_File(Argument(2), Text.all, Len);
    SZ42.Apply_Crypto(Machine, Text(1..Len));
    SZ42.Text_IO.Write_File(Argument(3), Text(1..Len));
end Cryptor;
