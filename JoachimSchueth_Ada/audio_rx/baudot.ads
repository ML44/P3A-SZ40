------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
package Baudot is
    type Symbol_T is mod 32;
    --type Shift_T is (Name, Letter, Figure);
    type Shift_T is (Letter, Figure);
    Font: constant array(Shift_T, Symbol_T) of Character :=
    (
        --Name   => "/T3O9HNM4LRGIPCVEZDBSYFXAWJ5UQK8",
        Letter => "iTrO_HNMnLRGIPCVEZDBSYFXAWJ<UQK>",
        Figure => "i5r9_h,.n)4g80:=3+d?'6f/-2j<71(>"
    );

    SC: array(Character) of Symbol_T;
    --SN: array(Character) of Symbol_T;

    procedure Process_Symbol(C: out Character; Shift: in out Shift_T;
        Symbol: in Symbol_T);

    procedure Print_Symbol(Shift: in out Shift_T; Symbol: in Symbol_T);

private
    procedure Make_Tables;
end Baudot;
