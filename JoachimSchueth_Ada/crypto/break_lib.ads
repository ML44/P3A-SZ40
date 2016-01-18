------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with SZ42;
with Score_Charts;

package Break_Lib is

    type Real is digits 16;

    type Probab_T is array(SZ42.Symbol_T) of Real;
    Unif_Prob: constant Probab_T := (others => 1.0 / Real(Probab_T'Length));

    type Counts_T is array(SZ42.Symbol_T) of Natural;

    procedure To_Prob(Prob: out Probab_T; Counts: in Counts_T);

    function Calc_Chi_Square(
        Text: SZ42.Symbol_String;
        Deltas: Boolean := False;
        Mot_Trace: SZ42.Motor_Trace_Access := null;
        Prob: Probab_T)
        return Real;

    package SCP is new Score_Charts(Real, SZ42.Wheel_Positions);
    use SCP;
    --subtype Score_Chart_T is SCP.Score_Chart_T;
    type Score_Chart_T is new SCP.Score_Chart_T;

    type Wheel_Set is array(Positive range <>) of SZ42.Wheel_Num;
    Chi_Wheels: constant Wheel_Set := (
        SZ42.Chi1, SZ42.Chi2, SZ42.Chi3, SZ42.Chi4, SZ42.Chi5);
    Psi_Wheels: constant Wheel_Set := (
        SZ42.Psi1, SZ42.Psi2, SZ42.Psi3, SZ42.Psi4, SZ42.Psi5);
    Motor_Wheels: constant Wheel_Set := (
        SZ42.Mu61, SZ42.Mu37);

    procedure Show_Chart(Chart: in Score_Chart_T; Wheels: Wheel_Set);

    procedure Mutate_Pos(
        Pos: in out SZ42.Wheel_Positions;
        Wheels: in Wheel_Set);

    procedure Randomise_Pos(
        Pos: in out SZ42.Wheel_Positions;
        Wheels: in Wheel_Set);

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
        Prob: Probab_T := Unif_Prob);

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
        Prob: Probab_T := Unif_Prob);

end Break_Lib;
