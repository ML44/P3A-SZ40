------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO, Ada.Streams.Stream_IO;
use  Ada.Text_IO, Ada.Streams.Stream_IO, Ada.Streams;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Command_Line;
use  Ada.Command_Line;

with Ada.IO_Exceptions;

procedure Demod is

    type Real is digits 12;

    Input_Filename: constant String := Argument(1);
    Sample_Rate: constant Real := Real'Value(Argument(2));
    Step_Len: constant Natural := Natural'Value(Argument(3));
    Arg_Freq_Offset: constant := 3;
    Num_Freq: constant Natural := Argument_Count - Arg_Freq_Offset;
    Window_Len: constant Natural := 4 * Step_Len;

    package Real_EF is new Ada.Numerics.Generic_Elementary_Functions(Real);
    use Real_EF;
    package RIO is new Ada.Text_IO.Float_IO(Real);
    use RIO;

    type Sample is range -16#8000# .. 16#7fff#;
    for Sample'Size use 16;

    type Real_Array is array(Positive range <>) of Real;
    type Sample_Array is array(Positive range <>) of Sample;

    type IQ_Burst is record
        I, Q: Real_Array(1..Window_Len);
    end record;

    Bursts: array(1..Num_Freq) of IQ_Burst;
    procedure Make_Bursts is
        Phase, Delta_Phase: Real;
        K0: constant Real := 0.5 * (1.0 + Real(Window_Len));
        Sigma: constant Real := 0.125 * Real(Window_Len);
        Amp: array(1..Window_Len) of Real;
    begin
        for K in Amp'Range loop
            Amp(K) := Exp(-0.5 * ((Real(K) - K0) / Sigma) ** 2);
        end loop;
        for B in Bursts'Range loop
            Delta_Phase := Real'Value(Argument(B + Arg_Freq_Offset))
                           / Sample_Rate;
            Phase := 0.0;
            for K in 1..Window_Len loop
                Phase := (Real(K) - K0) * Delta_Phase;
                Bursts(B).I(K) := Amp(K) * Cos(Phase, 1.0);
                Bursts(B).Q(K) := Amp(K) * Sin(Phase, 1.0);
            end loop;
        end loop;
    end;

    Sample_Buffer: Sample_Array(1..Step_Len);
    Real_Buffer: Real_Array(1..Window_Len) := (others => 0.0);
    procedure Feed_Buffer(Buffer: in out Real_Array; Data: in Sample_Array) is
        J: Positive := Buffer'First;
        K: Positive := Buffer'First + Data'Length;
    begin
        while K <= Buffer'Last loop
            Buffer(J) := Buffer(K);
            K := K + 1;
            J := J + 1;
        end loop;
        K := Data'First;
        while J <= Buffer'Last loop
            Buffer(J) := Real(Data(K));
            K := K + 1;
            J := J + 1;
        end loop;
        if K /= Data'Last + 1 then
            raise Program_Error;
        end if;    
    end Feed_Buffer;

    type Amplitude_Array is array(1..Num_Freq) of Real;
    procedure Calc_Amps(Amps: out Amplitude_Array) is
        ISum, QSum: Real;
    begin
        for F in 1..Num_Freq loop
            ISum := 0.0;
            QSum := 0.0;
            for K in 1..Window_Len loop
                ISum := ISum + Bursts(F).I(K) * Real_Buffer(K);
                QSum := QSum + Bursts(F).Q(K) * Real_Buffer(K);
            end loop;
            Amps(F) := Sqrt(ISum * ISum + QSum * QSum);
        end loop;
    end;

    Audio_File: Stream_IO.File_Type;
    Audio_Stream: Stream_Access;
    Amps: Amplitude_Array;
begin    
    Open(Audio_File, In_File, Input_Filename);
    Audio_Stream := Stream(Audio_File);
    Make_Bursts;
    -- while not End_of_File(Audio_File) loop
    loop
        Sample_Array'Read(Audio_Stream, Sample_Buffer);
        Feed_Buffer(Real_Buffer, Sample_Buffer);
        Calc_Amps(Amps);
        for F in 1..Num_Freq loop
            Put(' '); Put(Amps(F), Exp => 0, Fore => 6, Aft => 1);
        end loop;
        New_Line;
    end loop;
exception
    when Ada.IO_Exceptions.End_Error => null;
end Demod;
