------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO, Ada.Command_Line;
use  Ada.Text_IO, Ada.Command_Line;

procedure Discrim is
    Num_Freq: constant Natural := Argument_Count;
    type Real is digits 12;
    package RIO is new Ada.Text_IO.Float_IO(Real);
    use RIO;

    Weight: array(1..Num_Freq) of Real;
    Val, Sum: Real;
begin
    for F in 1..Num_Freq loop
        Weight(F) := Real'Value(Argument(F));
    end loop;
    while not End_of_File loop
        Sum := 0.0;
        for F in 1..Num_Freq loop
            Get(Val);
            Sum := Sum + Weight(F) * Val;
        end loop;
        Put(Sum, Fore => 6, Aft => 1, Exp => 0);
        New_Line;
    end loop;
end Discrim;
