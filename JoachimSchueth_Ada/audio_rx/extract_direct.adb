------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO, Ada.Command_Line;
use  Ada.Text_IO, Ada.Command_Line;
with Ada.Integer_Text_IO;
use  Ada.Integer_Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

with Baudot;

procedure Extract_Direct is
    type Real is digits 12;
    package RIO is new Ada.Text_IO.Float_IO(Real);
    use RIO;
    package REF is new Ada.Numerics.Generic_Elementary_Functions(Real);
    use REF;
    Window_Len: constant Natural := Natural(Real'Value(Argument(1)));
    Window_Mid: constant Natural := Natural(0.5 * Real'Value(Argument(1)));

    type CS_Pair is record
        C: Character;
        S: Real := Real'First;
    end record;    

    Buffer: array(1..Window_Len) of CS_Pair;
    Max_Idx: Natural := 1;
    Max_Score: Real := Real'First;
    procedure Feed_Buffer(CS: CS_Pair) is
    begin
        for I in Buffer'First .. Buffer'Last - 1 loop
            Buffer(I) := Buffer(I + 1);
        end loop;
        Buffer(Buffer'Last) := CS;
        Max_Idx := Max_Idx - 1;
        if Max_Idx < Buffer'First or else CS.S > Max_Score then
            Max_Score := Real'First;
            for I in Buffer'Range loop
                if Buffer(I).S > Max_Score then
                    Max_Score := Buffer(I).S;
                    Max_Idx := I;
                end if;    
            end loop;
        end if;
    end Feed_Buffer;

    Line_Counter: Natural := 0;
    Time, Last_Linetime: Real := 0.0;
    Shift: Baudot.Shift_T := Baudot.Letter;
    procedure Print_Character is
        Symbol: Baudot.Symbol_T;
        C: Character;
    begin
        Symbol := Baudot.SC(Buffer(Window_Mid).C);
        Baudot.Process_Symbol(C, Shift, Symbol);
        Put(C);
        Line_Counter := Line_Counter + 1;
        if Line_Counter >= 10 then
            Line_Counter := 0;
            Put(' ');
            Put(Natural(Last_Linetime), 8);
            Put(Natural(Time - Last_Linetime), 5);
            Last_Linetime := Time;
            New_Line;
        end if;
    end Print_Character;

    CS: CS_Pair;
begin
    while not End_of_File loop
        Time := Time + 1.0;
        Get(CS.C); Get(CS.S);
        Feed_Buffer(CS);
        if Max_Idx = Window_Mid then
            Print_Character;
        end if;    
    end loop;
end Extract_Direct;
