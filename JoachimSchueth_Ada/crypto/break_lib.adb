------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO;
use  Ada.Text_IO;
--with Ada.Integer_Text_IO;
--use  Ada.Integer_Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Float_Random;
use  Ada.Numerics.Float_Random;

with SZ42;

use type SZ42.Bit_Num, SZ42.Symbol_T, SZ42.Motor_Trace_Access;

package body Break_Lib is

    package REF is new Ada.Numerics.Generic_Elementary_Functions(Real);
    use REF;
    package RIO is new Ada.Text_IO.Float_IO(Real);
    use RIO;
    package BNIO is new Ada.Text_IO.Integer_IO(SZ42.Bit_Num);
    use BNIO;

    function Calc_Chi_Square(
        Text: SZ42.Symbol_String;
        Deltas: Boolean := False;
        Mot_Trace: SZ42.Motor_Trace_Access := null;
        Prob: Probab_T)
        return Real
    is
        Counts: Counts_T := (others => 0);
        S: SZ42.Symbol_T;
        Sum, D: Real := 0.0;
        Total: Natural := 0;
        RTotal: Real;
    begin
        if not Deltas then
            for I in Text'Range loop
                S := Text(I);
                Counts(S) := Counts(S) + 1;
            end loop;
            RTotal := Real(Text'Length);
        else        
            for I in Text'First .. Text'Last - 1 loop
                if Mot_Trace = null or else Mot_Trace(I) = False then
                    S := Text(I) xor Text(I + 1);
                    Counts(S) := Counts(S) + 1;
                    Total := Total + 1;
                end if;    
            end loop;
            RTotal := Real(Total);
        end if;
        for S in Counts'Range loop
            D := Real(Counts(S));
            Sum := Sum + D * D / Prob(S);
        end loop;
        return Sum / RTotal - RTotal;
    end Calc_Chi_Square;

    FRG: Ada.Numerics.Float_Random.Generator;

    generic
        type Num is range <>;
    function Generic_Int_Random(
        Min: Num := Num'First; 
        Max: Num := Num'Last)
        return Num;
    function Generic_Int_Random(
        Min: Num := Num'First; 
        Max: Num := Num'Last)
        return Num
    is    
        F: Float := Random(FRG);
    begin
        if F >= 1.0 then
            F := 0.0;
        end if;    
        F := Float(Min) + Float'Floor(Float(Max - Min + 1) * F);
        return Num(F);
    end Generic_Int_Random;

    function Positive_Random is new Generic_Int_Random(Positive);
    function Bit_Num_Random is new Generic_Int_Random(SZ42.Bit_Num);

    procedure Mutate_Pos(
        Pos: in out SZ42.Wheel_Positions;
        Wheels: in Wheel_Set)
    is
        W: SZ42.Wheel_Num;
        L: SZ42.Bit_Num;
        I: Integer;
    begin
        I := Positive_Random(Wheels'First, Wheels'Last);
        W := Wheels(I);
        loop
            L := Bit_Num_Random(1, SZ42.Wheel_Period(W));
            exit when Pos(W) /= L;
        end loop;    
        Pos(W) := L;
    end Mutate_Pos;

    procedure Randomise_Pos(
        Pos: in out SZ42.Wheel_Positions;
        Wheels: in Wheel_Set)
    is    
        W: SZ42.Wheel_Num;
    begin
        for I in Wheels'Range loop
            W := Wheels(I);
            Pos(W) := Bit_Num_Random(1, SZ42.Wheel_Period(W));
        end loop;
    end Randomise_Pos;

    procedure Carlo_Setting(
        In_Text: in SZ42.Symbol_String;
        Out_Text: out SZ42.Symbol_String;
        Pat: in SZ42.Wheel_Patterns;
        Pos: in out SZ42.Wheel_Positions;
        Lim: SZ42.Limitation_T;
        Use_Psi: in Boolean;
        Mot_Trace: in SZ42.Motor_Trace_Access;
        Wheels: in Wheel_Set;
        Chart: in out Score_Chart_T;
        Max_No_Progress: Positive := 500;
        Prob: Probab_T := Unif_Prob)
    is
        Machine: SZ42.Machine;
        New_Score: Real;
        Best_Score: Real := Real'First;
        Best_Pos: SZ42.Wheel_Positions;
        No_Progress_Count: Natural;
        Score_Sign: Real;
    begin
        if Prob = Unif_Prob then
            Score_Sign := 1.0;
        else
            Score_Sign := -1.0;
        end if;    
        SZ42.Init_Machine(Machine, Pat, Pos, Lim, Use_Psi);
        No_Progress_Count := 0;
        loop
            SZ42.Set_Positions(Machine, Pos);

            SZ42.Apply_Crypto(
                Machine, 
                In_Text, 
                Out_Text,
                Mot_Trace => Mot_Trace);

            New_Score := Score_Sign * Calc_Chi_Square(
                Out_Text,
                Deltas => (not Use_Psi) or (Mot_Trace /= null),
                Mot_Trace => Mot_Trace,
                Prob => Prob);

            Insert_Score(Chart, New_Score, Pos);

            if New_Score > Best_Score then
                Best_Pos := Pos;
                Best_Score := New_Score;
                No_Progress_Count := 0;
            else
                Pos := Best_Pos;
                No_Progress_Count := No_Progress_Count + 1;
                exit when No_Progress_Count > Max_No_Progress;
            end if;

            Mutate_Pos(Pos, Wheels);
        end loop;    
    end Carlo_Setting;

    procedure Reset_Pos(
        Pos: in out SZ42.Wheel_Positions;
        Wheels: in Wheel_Set)
    is
    begin
        for I in Wheels'Range loop
            Pos(Wheels(I)) := SZ42.Bit_Num'First;
        end loop;
    end Reset_Pos;

    procedure Progress_Pos(
        Pos: in out SZ42.Wheel_Positions;
        Wheels: in Wheel_Set;
        Done: out Boolean)
    is
        W: SZ42.Wheel_Num;
    begin
        Done := False;
        for I in Wheels'Range loop
            W := Wheels(I);
            if Pos(W) /= SZ42.Wheel_Period(W) then
                Pos(W) := Pos(W) + 1;
                return;
            else
                Pos(W) := SZ42.Bit_Num'First;
            end if;    
        end loop;
        Done := True;
    end Progress_Pos;

    procedure Brute_Setting(
        In_Text: in SZ42.Symbol_String;
        Out_Text: out SZ42.Symbol_String;
        Pat: in SZ42.Wheel_Patterns;
        Pos: in out SZ42.Wheel_Positions;
        Lim: SZ42.Limitation_T;
        Use_Psi: in Boolean;
        Mot_Trace: in SZ42.Motor_Trace_Access;
        Wheels: in Wheel_Set;
        Chart: in out Score_Chart_T;
        Prob: Probab_T := Unif_Prob)
    is
        Machine: SZ42.Machine;
        New_Score, Score_Sign: Real;
        Done: Boolean;
    begin
        if Prob = Unif_Prob then
            Score_Sign := 1.0;
        else
            Score_Sign := -1.0;
        end if;    
        SZ42.Init_Machine(Machine, Pat, Pos, Lim, Use_Psi);
        Reset_Pos(Pos, Wheels);
        Done := False;
        while not Done loop
            SZ42.Set_Positions(Machine, Pos);
            SZ42.Apply_Crypto(
                Machine,
                In_Text,
                Out_Text,
                Mot_Trace => Mot_Trace);
            New_Score := Score_Sign * Calc_Chi_Square(
                Out_Text, 
                Deltas => (not Use_Psi) or (Mot_Trace /= null), 
                Mot_Trace => Mot_Trace,
                Prob => Prob);
            Insert_Score(Chart, New_Score, Pos);
            Progress_Pos(Pos, Wheels, Done);
        end loop;    
        Pos := Chart(1).Item;
    end Brute_Setting;

    procedure To_Prob(Prob: out Probab_T; Counts: in Counts_T) is
        Total: Natural := 0;
        RTotal: Real;
    begin
        for I in Counts'Range loop
            Total := Total + Counts(I);
        end loop;
        RTotal := Real(Total);
        for I in Prob'Range loop
            Prob(I) := Real(Counts(I)) / RTotal;
        end loop;    
    end To_Prob;

    procedure Show_Chart(Chart: in Score_Chart_T; Wheels: Wheel_Set) is
    begin
        for I in reverse Chart'Range loop
            if Chart(I).Score > Real'First then
                Put(Chart(I).Score, 5, 3, 0); Put(' ');
                for K in Wheels'Range loop
                    Put(' '); Put(Chart(I).Item(Wheels(K)), 2);
                end loop;
                New_Line;
            end if;    
        end loop;
    end Show_Chart;

begin
    Reset(FRG);
end Break_Lib;    
