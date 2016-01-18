------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO;
use  Ada.Text_IO;

package body SZ42 is

    function Wheel_Value(M: Machine; W: Wheel_Num) return Symbol_T is
    begin
        return M.Symbols(W, M.Positions(W));
    end;
    pragma Inline(Wheel_Value);

    function Total_Motor(M: Machine) return Boolean is
        BM: constant Boolean := Wheel_Value(M, Mu37) /= 0;
        TM: Boolean;
    begin
        case M.Lim is
            when Lim_None => TM := BM;
            when Lim_Chi2 => TM := (M.Chi2_Back = 0) or BM;
        end case;
        return TM;
    end Total_Motor;
    pragma Inline(Total_Motor);

    procedure Adjust_Chi2_Back(M: in out Machine) is
        P: Bit_Num;
    begin
        P := M.Positions(Chi2);
        if P = Bit_Num'First then
            P := Wheel_Period(Chi2);
        else    
            P := P - 1;
        end if;    
        M.Chi2_Back := M.Symbols(Chi2, P);
    end Adjust_Chi2_Back;

    procedure Set_Positions(M: in out Machine; Pos: Wheel_Positions) is
    begin
        M.Positions := Pos;
        Adjust_Chi2_Back(M);
        M.TM := Total_Motor(M);
    end Set_Positions;    

    procedure Reset(M: in out Machine) is
    begin
        Set_Positions(M, M.Start_Positions);
    end Reset;

    procedure Init_Machine(
        M: out Machine;
        Pat: in Wheel_Patterns;
        Pos: in Wheel_Positions;
        Lim: in Limitation_T;
        Use_Psi: in Boolean := True)
    is
        W_Last: Wheel_Num;
    begin
        M.Use_Psi := Use_Psi;
        M.Lim := Lim;
        if Use_Psi then
            W_Last := Wheel_Num'Last;
        else    
            W_Last := Chi5;
        end if;
        for W in Wheel_Num'First..W_Last loop
            for L in 1..Wheel_Period(W) loop
                case Pat(W, L) is
                    when 0 => M.Symbols(W, L) := 0;
                    when 1 => M.Symbols(W, L) := Wheel_Mask(W);
                end case;
            end loop;
        end loop;
        M.Start_Positions := Pos;
        Reset(M);
    end;

    procedure Advance_Wheel(M: in out Machine; W: Wheel_Num) is
    begin
        if M.Positions(W) = Wheel_Period(W) then
            M.Positions(W) := Bit_Num'First;
        else    
            M.Positions(W) := M.Positions(W) + 1;
        end if;    
    exception
        when others => 
        Put("Exception: W=" & Wheel_Num'Image(W) & " Pos="
            & Bit_Num'Image(M.Positions(W)));
        New_Line;
        raise;
    end;
    pragma Inline(Advance_Wheel);

    procedure Machine_Step(M: in out Machine) is
        TM: constant Boolean := M.TM;
    begin
        M.Chi2_Back := Wheel_Value(M, Chi2);
        for W in Chi1..Chi5 loop
            Advance_Wheel(M, W);
        end loop;
        if M.Use_Psi then
            if Wheel_Value(M, Mu61) /= 0 then
                Advance_Wheel(M, Mu37);
            end if;    
            Advance_Wheel(M, Mu61);
            if TM then
                for W in Psi1..Psi5 loop
                    Advance_Wheel(M, W);
                end loop;    
            end if;
            M.TM := Total_Motor(M);
			M.BM := Total_Motor(M);
        end if;
    end Machine_Step;

    function Get_Chi_Symbol(M: Machine) return Symbol_T is
        K: Symbol_T := 0;
    begin
        for W in Chi1..Chi5 loop
            K := K xor Wheel_Value(M, W);
        end loop;
        return K;
    end Get_Chi_Symbol;    

    function Get_Psi_Symbol(M: Machine) return Symbol_T is
        K: Symbol_T := 0;
    begin
        for W in Psi1..Psi5 loop
            K := K xor Wheel_Value(M, W);
        end loop;
        return K;
    end Get_Psi_Symbol;    

    function Get_Key_Symbol(M: Machine) return Symbol_T is
        K: Symbol_T;
    begin
        K := Get_Chi_Symbol(M);
        if M.Use_Psi then
            K := K xor Get_Psi_Symbol(M);
        end if;
        return K;
    end;
    pragma Inline(Get_Chi_Symbol, Get_Psi_Symbol, Get_Key_Symbol);

    procedure Apply_Crypto(
        M: in out Machine;
        X: in Symbol_String;
        Y: out Symbol_String;
        Trace: Machine_Trace_Access := null;
        Mot_Trace: Motor_Trace_Access := null)
    is
    begin
        for I in X'Range loop
            if Trace /= null then
                Trace(I).Pos := M.Positions;
                Trace(I).Chi_Sym := Get_Chi_Symbol(M);
                Trace(I).Psi_Sym := Get_Psi_Symbol(M);
                Trace(I).TM := M.TM;
				Trace(I).M1 := (Wheel_Value(M, Mu61)=1) ;
				Trace(I).M2 := (Wheel_Value(M, Mu37)=1) ;
            end if;
            if Mot_Trace /= null then
                Mot_Trace(I) := M.TM;
            end if;
            Y(I) := X(I) xor Get_Key_Symbol(M);
            Machine_Step(M);
        end loop;
    end;

    procedure Apply_Crypto(
        M: in out Machine;
        X: in out Symbol_String;
        Trace: Machine_Trace_Access := null;
        Mot_Trace: Motor_Trace_Access := null)
    is
    begin
        Apply_Crypto(M, X, X, Trace, Mot_Trace);
    end;

end SZ42;
