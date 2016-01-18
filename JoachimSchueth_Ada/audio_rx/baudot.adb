------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
with Ada.Text_IO;
use  Ada.Text_IO;

Package body Baudot is

    procedure Make_Tables is
        C: Character;
    begin
        for C in SC'Range loop
            SC(C) := Symbol_T'First;
            --SN(C) := Symbol_T'First;
        end loop;    
        for Shift in Shift_T loop
            for Symbol in Symbol_T loop
                C := Font(Shift, Symbol);
                case Shift is
                    when Figure | Letter =>
                        if SC(C) /= Symbol_T'First and then SC(C) /= Symbol then
                            raise Program_Error;
                        end if;    
                        SC(C) := Symbol;
                    --when Name =>
                    --    SN(C) := Symbol;
                end case;        
            end loop;
        end loop;
    end Make_Tables;

    procedure Process_Symbol(C: out Character; Shift: in out Shift_T;
        Symbol: in Symbol_T)
    is
    begin
        C := Font(Shift, Symbol);
        --if Shift /= Name then
            if C = '<' then
                Shift := Figure;
            elsif C = '>' then
                Shift := Letter;
            end if;    
        --end if;    
    end Process_Symbol;

    procedure Print_Symbol(Shift: in out Shift_T; Symbol: Symbol_T) is
        C: Character;
    begin
        Process_Symbol(C, Shift, Symbol);
        case C is
            when 'n'|'r' =>
                New_Line;
            when '<' | '>' | 'i' =>
                null;
            when '_' =>
                Put(' ');
            when others =>
                Put(C);
        end case;
    end;
begin
    Make_Tables;
end Baudot;
