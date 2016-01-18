------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Integer_Text_IO;
use  Ada.Integer_Text_IO;
with Ada.Characters.Latin_1;
use  Ada.Characters.Latin_1;

package body SZ42.Text_IO is

    Is_Face: array(Character) of Boolean;
    Sym_Val: array(Character) of Symbol_T;

    procedure Read_File(File_Name: in String; Data: out Symbol_String;
        Len: out Natural)
    is
        File: File_Type;
        Ignore: Boolean := False;
        C: Character;
    begin
        Open(File, In_File, File_Name);
        Len := 0;
        while not End_of_File(File) loop
            Get_Immediate(File, C);
            if C = CR or C = LF then
                Ignore := False;
            elsif not Ignore then
                if Is_Face(C) then
                    Len := Len + 1;
                    Data(Len) := Sym_Val(C);
                else
                    Ignore := True;
                end if;
            end if;
        end loop;
        Close(File);
    end Read_File;

    procedure Write_File(File_Name: in String; Data: in Symbol_String;
        Initial_Shift: in Shift_T := Letter)
    is
        File: File_Type;
        Line_Count: Natural := 0;
        Shift: Shift_T := Initial_Shift;
        C: Character;
    begin
        Create(File, Out_File, File_Name);
        for I in Data'Range loop
            C := Face(Shift, Data(I));
            Put(File, C);
            Line_Count := Line_Count + 1;
            if Line_Count = 72 then
                New_Line(File);
                Line_Count := 0;
            end if;
            if Data(I) = Figure_Symbol then
                Shift := Figure;
            elsif Data(I) = Letter_Symbol then
                Shift := Letter;
            end if;    
        end loop;
        if Line_Count /= 0 then
            New_Line(File);
        end if;    
        Close(File);
    end Write_File;

    procedure Read_Key(
        File_Name: in String;
        Pat: out Wheel_Patterns;
        Pos: out Wheel_Positions;
        Lim: out Limitation_T)
    is
        File: File_Type;
        package PosIO is new Ada.Text_IO.Integer_IO(Bit_Num);
        Line: String(1..132);
        Len: Natural;
        I: Bit_Num;
    begin
        Open(File, In_File, File_Name);
        for W in Wheel_Num loop
            Get_Line(File, Line, Len);
            if Len /= Natural(Wheel_Period(W)) then
                Put(Wheel_Num'Image(W)); 
                Put(" pattern has wrong length, expecting ");
                Put(Integer(Wheel_Period(W)), 0);
                Put(".");
                New_Line;
                Put("Offending string: '"); Put(Line(1..Len)); Put(''');
                New_Line;
                raise Constraint_Error;
            end if;    
            I := Bit_Num'First;
            for L in 1..Len loop
                case Line(L) is
                    when '.' | '0' => Pat(W, I) := 0;
                    when 'x' | '1' => Pat(W, I) := 1;
                    when others =>
                        Put(Wheel_Num'Image(W)); 
                        Put(": Bad character in key file: "); Put(Line(L));
                        New_Line; 
                        raise Constraint_Error;
                end case;
                I := I + 1;
            end loop;
        end loop;
        for W in Wheel_Num loop
            Get(File, Positive(Pos(W)));
        end loop;
        Get_Line(File, Line, Len);
        Lim := Limitation_T'Value(Line(1..Len));
        Close(File);
    end Read_Key;

    procedure Print_Key(
        Pat: Wheel_Patterns; 
        Pos: Wheel_Positions;
        Lim: Limitation_T := Lim_None)
    is    
    begin
        for W in Wheel_Num loop
            for P in 1..Wheel_Period(W) loop
                case Pat(W, P) is
                    when 0 => Put('.');
                    when 1 => Put('x');
                end case;    
            end loop;
            New_Line;
        end loop;
        for W in Wheel_Num loop
            Put(Integer(Pos(W)), 2);
            case W is
                when Chi5 | Mu37 | Psi5 => Put("   ");
                when others => Put(' ');
            end case;    
        end loop;    
        Put(Limitation_T'Image(Lim));
    end Print_Key;

begin        
    Sym_Val := (Character => 0);
    Is_Face := (Character => False);
    for Shift in Shift_T loop
        for Sym in Symbol_T loop
            Is_Face(Face(Shift, Sym)) := True;
            Sym_Val(Face(Shift, Sym)) := Sym;
        end loop;
    end loop;
end SZ42.Text_IO;
