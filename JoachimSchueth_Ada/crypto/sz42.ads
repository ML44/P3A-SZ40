------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
package SZ42 is
    type Bit is mod 2;
    type Symbol_T is mod 32;
    type Symbol_String is array(Positive range <>) of Symbol_T;

    type Bit_Num is range 1..62;
    type Wheel_Num is (Chi1, Chi2, Chi3, Chi4, Chi5,
        Mu61, Mu37, Psi1, Psi2, Psi3, Psi4, Psi5);
    Wheel_Period: constant array(Wheel_Num) of Bit_Num
                := (41, 31, 29, 26, 23, 61, 37, 43, 47, 51, 53, 59);

    Wheel_Mask: constant array(Wheel_Num) of Symbol_T
              := (16, 8, 4, 2, 1, 1, 1, 16, 8, 4, 2, 1);
    type Limitation_T is (Lim_None, Lim_Chi2);

    type Machine is limited private;
    type Wheel_Patterns is array(Wheel_Num, Bit_Num) of Bit;
    type Wheel_Positions is array(Wheel_Num) of Bit_Num;
    type Machine_State is record
        Pos: Wheel_Positions;
        Chi_Sym, Psi_Sym: Symbol_T;
        BM, TM: Boolean;
    end record;
    type Machine_Trace is array(Positive range <>) of Machine_State;
    type Machine_Trace_Access is access Machine_Trace;
    type Motor_Trace is array(Positive range <>) of Boolean;
    type Motor_Trace_Access is access Motor_Trace;

    procedure Init_Machine(
        M: out Machine;
        Pat: in Wheel_Patterns;
        Pos: in Wheel_Positions;
        Lim: Limitation_T;
        Use_Psi: in Boolean := True);
    procedure Set_Positions(M: in out Machine; Pos: Wheel_Positions);
    procedure Reset(M: in out Machine);

    procedure Apply_Crypto(
        M: in out Machine;
        X: in out Symbol_String;
        Trace: Machine_Trace_Access := null;
        Mot_Trace: Motor_Trace_Access := null);
    procedure Apply_Crypto(
        M: in out Machine;
        X: in Symbol_String;
        Y: out Symbol_String;
        Trace: Machine_Trace_Access := null;
        Mot_Trace: Motor_Trace_Access := null);
private
    type Wheel_Symbols is array(Wheel_Num, Bit_Num) of Symbol_T;
    type Machine is limited record
        Symbols: Wheel_Symbols;
        Positions, Start_Positions: Wheel_Positions;
        Use_Psi: Boolean;
        Lim: Limitation_T;
        Chi2_Back: Symbol_T;
        TM: Boolean;
    end record;    
end SZ42;
