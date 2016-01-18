------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
--- noch in Entwicklung...
with Ada.Text_IO, Ada.Command_Line;
use  Ada.Text_IO, Ada.Command_Line;
--with Ada.Integer_Text_IO;
--use  Ada.Integer_Text_IO;
with SZ42;
with SZ42.Text_IO;
with Break_Lib;
use  Break_Lib;

use type SZ42.Bit_Num, SZ42.Symbol_T;

procedure Quick_Setting is
    Max_Text_Len: constant := 100000;

    type Symbol_String_Access is access SZ42.Symbol_String;
    In_Text, Out_Text: Symbol_String_Access;
    Len: Natural;

    Pat: SZ42.Wheel_Patterns;
    Pos: SZ42.Wheel_Positions := (others => 1);
    Lim: SZ42.Limitation_T;
    M: SZ42.Machine;
    Motor: SZ42.Motor_Trace_Access;
    Chart_1: Score_Chart_T(1..10) := (others => (-1.0, Pos));
    Chart_2: Score_Chart_T(1..10) := (others => (-1.0, Pos));
    Chart_3: Score_Chart_T(1..10) := (others => (-1.0, Pos));
begin
    SZ42.Text_IO.Read_Key(Argument(1), Pat, Pos, Lim);
    In_Text := new SZ42.Symbol_String(1..Max_Text_Len);
    SZ42.Text_IO.Read_File(Argument(2), In_Text.all, Len);
    Out_Text := new SZ42.Symbol_String(1..Len);
    Motor := new SZ42.Motor_Trace(1..Len);

    Randomise_Pos(Pos, Psi_Wheels);
    Randomise_Pos(Pos, Motor_Wheels);
    for I in 1..10 loop
    Randomise_Pos(Pos, Chi_Wheels);
        Carlo_Setting(
            In_Text(1..Len),
            Out_Text.all,
            Pat, Pos, Lim,
            False, null,
            Chi_Wheels,
            Chart_1,
            1000);
    end loop;    
    Put_Line("Chart after Chi setting:");
    Show_Chart(Chart_1, Chi_Wheels);
    New_Line;

    Pos := Chart_1(1).Item;
    Brute_Setting(
        In_Text(1..Len),
        Out_Text.all,
        Pat, Pos, Lim,
        True, Motor,
        Motor_Wheels,
        Chart_2);
    Put_Line("Chart after Motor setting:");
    Show_Chart(Chart_2, Chi_Wheels & Motor_Wheels);
    New_Line;

    Pos := Chart_2(1).Item;
    Carlo_Setting(
        In_Text(1..Len),
        Out_Text.all,
        Pat, Pos, Lim,
        True, null,
        Psi_Wheels, 
        Chart_3, 1000);
    Put_Line("Chart after Psi setting:");
    Show_Chart(Chart_3, Chi_Wheels & Motor_Wheels & Psi_Wheels);
    New_Line;

    Pos := Chart_3(1).Item;
    SZ42.Text_IO.Print_Key(Pat, Pos, Lim);

    SZ42.Init_Machine(M, Pat, Pos, Lim);
    SZ42.Apply_Crypto(M, In_Text(1..Len));
    SZ42.Text_IO.Write_File("plain.out", In_Text(1..Len));

end Quick_Setting;
