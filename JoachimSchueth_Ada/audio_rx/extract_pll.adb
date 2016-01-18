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

procedure Extract_PLL is
    type Real is digits 12;
    type Real_Array is array(Positive range <>) of Real;
    package RIO is new Ada.Text_IO.Float_IO(Real);
    use RIO;
    package REF is new Ada.Numerics.Generic_Elementary_Functions(Real);
    use REF;

    Arg_Winlen: constant := 1;
    Arg_PLL_A: constant := 2;
    Arg_PLL_B: constant := 3;
    Window_Len: constant Natural := Natural(Real'Value(Argument(Arg_Winlen)));
    Window_Mid: constant Natural := Natural(0.5 * Real'Value(Argument(Arg_Winlen)));

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

    Num_Deltas: constant := 10;
    DT_Buffer: Real_Array(1..Num_Deltas) := (others => 0.0);
    Time, Last_Time, Next_Time: Real := 0.0;
    DT_Mean, DT_Sdev: Real := 0.0;
    PLL_Locked: Boolean := False;
    PLL_Period: Real := 0.0;
    PLL_A: Real := 0.1;
    PLL_B: Real := 0.25 * PLL_A * PLL_A;
    PLL_Count: Natural := 0;
    PLL_Diff_Sum: Real := 0.0;

    procedure Update_Deltas is
        S, S2: Real := 0.0;
    begin
        for I in DT_Buffer'First .. DT_Buffer'Last - 1 loop
            DT_Buffer(I) := DT_Buffer(I + 1);
        end loop;
        DT_Buffer(DT_Buffer'Last) := Time - Last_Time;
        Last_Time := Time;

        for I in DT_Buffer'Range loop
            S := S + DT_Buffer(I);
            S2 := S2 + DT_Buffer(I) * DT_Buffer(I);
        end loop;
        S := S / Real(Num_Deltas);
        S2 := S2 / Real(Num_Deltas);
        DT_Mean := S;
        DT_Sdev := Sqrt(S2 - S * S);
    end Update_Deltas;

    procedure Update_PLL is
        Diff: Real;
    begin
        Update_Deltas;
        if not PLL_Locked then
            if DT_Sdev / Sqrt(Real(Num_Deltas - 1)) < 0.01 * DT_Mean then
                PLL_Locked := True;
                PLL_Period := DT_Mean;
                Next_Time := Time + DT_Mean;
            end if;    
        else    
            Diff := Time - Next_Time;
            if Diff < -0.5 * PLL_Period then
                Diff := Diff + PLL_Period;
            end if;
            if Abs(Diff) < 0.05 * PLL_Period then
                PLL_Count := PLL_Count + 1;
                PLL_Diff_Sum := PLL_Diff_Sum + Diff;
                Next_Time := Next_Time + PLL_A * Diff;
                PLL_Period := PLL_Period + PLL_B * Diff;
            end if;
            --New_Line;
            --Put(Time, Fore => 6, Aft => 3, Exp => 0); Put("   ");
            --Put(Next_Time, Fore => 6, Aft => 3, Exp => 0); Put("   ");
            --Put(Diff, Fore => 6, Aft => 3, Exp => 0); Put("   ");
            --Put(PLL_Period, Fore => 6, Aft => 3, Exp => 0); Put("   ");
        end if;    
    end Update_PLL;    

    Line_Counter: Natural := 0;
    Last_Linetime: Real := 0.0;
    Shift: Baudot.Shift_T := Baudot.Letter;
    procedure Print_Character is
        C: Character;
    begin
        Baudot.Process_Symbol(C, Shift, Baudot.SC(Buffer(Window_Mid).C));
        Put(C);
        Flush(Current_Output);
        --Put(" ");
        --Put(Time, Fore => 6, Aft => 0, Exp => 0); Put(" ");
        --Put(Next_Time, Fore => 6, Aft => 3, Exp => 0);
        --New_Line;
        Line_Counter := Line_Counter + 1;
        if Line_Counter >= 10 then
            Line_Counter := 0;
            Put(Natural(Last_Linetime), 8); Put(' ');
            Put(Natural(Time - Last_Linetime), 5); Put(' ');
            Put(DT_Mean, Fore => 3, Aft => 3, Exp => 0); Put(' ');
            Put(DT_Sdev / Sqrt(Real(Num_Deltas - 1)), Fore => 2, Aft => 3, Exp => 0);
            if PLL_Locked then
                Put(' ');
                Put(PLL_Count, 3); Put(' ');
                if PLL_Count /= 0 then
                    Put(PLL_Diff_Sum / Real(PLL_Count), Fore => 3, Aft => 3, Exp => 0);
                else
                    Put("       ");
                end if;
                Put(' ');
                Put(PLL_Period, Fore => 4, Aft => 3, Exp => 0);
            end if;    
            PLL_Count := 0;
            PLL_Diff_Sum := 0.0;
            Last_Linetime := Time;
            New_Line;
        end if;
    end Print_Character;

    CS: CS_Pair;
begin
    if Argument_Count >= Arg_PLL_A then
        PLL_A := Real'Value(Argument(Arg_PLL_A));
    end if;    
    if Argument_Count >= Arg_PLL_B then
        PLL_B := Real'Value(Argument(Arg_PLL_B));
    end if;    

    while not End_of_File loop
        Time := Time + 1.0;
        Get(CS.C); Get(CS.S);
        Feed_Buffer(CS);
        if Max_Idx = Window_Mid then
            if not PLL_Locked then
                Print_Character;
            end if;    
            Update_PLL;
        end if;    
        if PLL_Locked and Time > Next_Time - 0.5 then
            Print_Character;
            Next_Time := Next_Time + PLL_Period;
        end if;
    end loop;
end Extract_PLL;
