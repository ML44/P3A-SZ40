------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Integer_Text_IO;
use  Ada.Integer_Text_IO;
with Ada.Command_Line;
use  Ada.Command_Line;
with SZ42;
with SZ42.Text_IO;

procedure CrypTrace is

    type Symbol_String_Access is access SZ42.Symbol_String;
    use type SZ42.Symbol_T, SZ42.Wheel_Num;

    procedure Put_Symbol_Bits(Sym: SZ42.Symbol_T) is
    begin
        for K in Integer range 1..5 loop
            if (Sym and (2 ** (5 - K))) /= 0 then 
                Put('x');
            else
                Put('.');
            end if;    
        end loop;
    end Put_Symbol_Bits;

    procedure Print_Sym(Sym: SZ42.Symbol_T) is
    begin
        Put(SZ42.Text_IO.Face(SZ42.Text_IO.Letter, Sym));
    end Print_Sym;

    Pat: SZ42.Wheel_Patterns;
    Pos: SZ42.Wheel_Positions;
    Lim: SZ42.Limitation_T;

    Machine: SZ42.Machine;
    Trace: SZ42.Machine_Trace_Access;
    Data_In, Data_Out: Symbol_String_Access;
    Len: Natural;
begin
    SZ42.Text_IO.Read_Key(Argument(1), Pat, Pos, Lim);
    Data_In := new SZ42.Symbol_String(1..20000);
    SZ42.Text_IO.Read_File(Argument(2), Data_In.all, Len);
    Data_Out := new SZ42.Symbol_String(1..Len);
    Trace := new SZ42.Machine_Trace(1..Len);
    SZ42.Init_Machine(Machine, Pat, Pos, Lim);

    SZ42.Apply_Crypto(Machine, Data_In(1..Len), Data_Out(1..Len), Trace);
    Put_Line(" Step   Input    Output   K1 K2 K3 K4 K5  M1 M2  S1 S2 S3 S4 S5"
           & "  Chi   Psi   TM");
    for I in 1..Len loop
        Put(I, 5); Put(":  ");
        Print_Sym(Data_In(I)); Put(' ');
        Put_Symbol_Bits(Data_In(I)); Put("  ");
        Print_Sym(Data_Out(I)); Put(' ');
        Put_Symbol_Bits(Data_Out(I)); Put(' ');
        for W in SZ42.Wheel_Num loop
            case W is
                when SZ42.Mu61 | SZ42.Psi1 => Put("  ");
                when others => Put(' ');
            end case;
            Put(Integer(Trace(I).Pos(W)), 2);
        end loop;
        Put("  ");
        Put_Symbol_Bits(Trace(I).Chi_Sym);
        Put(' ');
        Put_Symbol_Bits(Trace(I).Psi_Sym);
        Put("  ");
        if Trace(I).TM then
            Put('x');
        else
            Put('.');
        end if;    
        New_Line;
    end loop;
end CrypTrace;
