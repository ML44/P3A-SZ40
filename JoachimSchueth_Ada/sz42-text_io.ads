------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
package SZ42.Text_IO is

    type Shift_T is (Letter, Figure);

    Face: constant array(Shift_T, Symbol_T) of Character := (
        --Letter => "iTrO_HNMnLRGIPCVEZDBSYFXAWJ^UQKv",
        --Figure => "i5r9_h,.n)4g80:=3+d?'6f/-2j^71(v");    
        Letter => "iTrO_HNMnLRGIPCVEZDBSYFXAWJ<UQK>",
        Figure => "i5r9_h,.n)4g80:=3+d?'6f/-2j<71(>");    
    Letter_Symbol:  constant Symbol_T := 2#11111#;    
    Figure_Symbol:  constant Symbol_T := 2#11011#;
    Return_Symbol:  constant Symbol_T := 2#00010#;
    Newline_Symbol: constant Symbol_T := 2#01000#;
    Ignore_Symbol:  constant Symbol_T := 2#00000#;
    Space_Symbol:   constant Symbol_T := 2#00100#;

    procedure Read_File(
        File_Name: in String;
        Data: out Symbol_String;
        Len: out Natural);

    procedure Write_File(
        File_Name: in String;
        Data: in Symbol_String;
        Initial_Shift: in Shift_T := Letter);

    procedure Read_Key(
        File_Name: String;
        Pat: out Wheel_Patterns;
        Pos: out Wheel_Positions;
        Lim: out Limitation_T); 

    procedure Print_Key(
        Pat: Wheel_Patterns;
        Pos: Wheel_Positions;
        Lim: Limitation_T := Lim_None);

end SZ42.Text_IO;
