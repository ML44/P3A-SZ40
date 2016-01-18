------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO, Ada.Command_Line;
use  Ada.Text_IO, Ada.Command_Line;

with Baudot;
use type Baudot.Symbol_T;

procedure Decode is

    subtype Symbol_T is Baudot.Symbol_T;
    type Real is digits 12;
    package RIO is new Ada.Text_IO.Float_IO(Real);
    use RIO;
    Bit_Len: constant Real := Real'Value(Argument(1));
    Pattern_Length: constant Natural := Natural(9.0 * Bit_Len);
    type Pattern_Index is new Integer range 1..Pattern_Length;

    Symbol_Pattern: array(Symbol_T, Pattern_Index) of Real;
    procedure Make_Patterns is
        T: Real;
        Bit_Index: Natural;
    begin
        for L in Symbol_T loop
            for K in Pattern_Index loop
                T := (Real(K) - Real(Pattern_Index'First)) / Bit_Len; 
                if T < 1.5 or else T >= 7.5 then
                    Symbol_Pattern(L, K) := 1.0;
                elsif T < 2.5 then
                    Symbol_Pattern(L, K) := -1.0;
                else
                    Bit_Index := 1;
                    while Bit_Index <= 5 loop
                        exit when T < Real(Bit_Index) + 2.5;
                        Bit_Index := Bit_Index + 1;
                    end loop;
                    if (L and (2 ** (5 - Bit_Index))) /= 0 then
                        Symbol_Pattern(L, K) := 1.0;
                    else
                        Symbol_Pattern(L, K) := -1.0;
                    end if;    
                end if;
            end loop;    
        end loop;
    end Make_Patterns;

    Buffer: array(Pattern_Index) of Real := (others => 0.0);
    procedure Feed_Buffer(Val: Real) is
    begin
        for K in Buffer'First .. Buffer'Last - 1 loop
            Buffer(K) := Buffer(K + 1);
        end loop;
        Buffer(Buffer'Last) := Val;
        --if Val > 0.0 then
        --    Buffer(Buffer'Last) := 1.0;
        --else
        --    Buffer(Buffer'Last) := -1.0;
        --end if;    
    end Feed_Buffer;

    Offset: Real := 0.0;
    Score: array(Symbol_T) of Real;
    procedure Calc_Scores is
        Sum: Real;
    begin
        for L in Symbol_T loop
            Sum := 0.0;
            for K in Pattern_Index loop
                Sum := Sum + Symbol_Pattern(L, K) * (Buffer(K) - Offset);
            end loop;
            Score(L) := Sum;
        end loop;
    end Calc_Scores;

    procedure Find_Best_Score(LMax: out Symbol_T) is
        Max: Real := Real'First;
    begin
        LMax := Symbol_T'First;
        for L in Symbol_T loop
            if Score(L) > Max then
                LMax := L;
                Max := Score(L);
            end if;
        end loop;
    end Find_Best_Score;

    Value: Real;
    LMax: Symbol_T;
begin
    if Argument_Count > 1 then
        Offset := Real'Value(Argument(2));
    end if;
    Make_Patterns;
    while not End_of_File loop
        Get(Value);
        Feed_Buffer(Value);
        Calc_Scores;
        Find_Best_Score(LMax);
        Put(Baudot.Font(Baudot.Letter, Lmax)); Put(' '); 
        Put(Score(LMax), Fore => 7, Aft => 2, Exp => 0);
        new_Line;
    end loop;

end Decode;
