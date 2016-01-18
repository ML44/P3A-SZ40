------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
package body Score_Charts is

    procedure Insert_Score(Chart: in out Score_Chart_T;
        New_Score: in Score_Type;
        New_Item: in Item_Type)
    is
        Pos: Positive;
    begin
        if New_Score <= Chart(Chart'Last).Score then
            return;
        end if;    
        Pos := Chart'First;
        while Pos <= Chart'Last loop
            exit when not (New_Score <= Chart(Pos).Score);
            if New_Score = Chart(Pos).Score and then Chart(Pos).Item = New_Item
            then
                return;
            end if;    
            Pos := Pos + 1;
        end loop;
        --if Pos > Chart'Last then -- should never happen?
        --    return;
        --end if;    
        for P in reverse Pos + 1 .. Chart'Last loop
            Chart(P) := Chart(P - 1);
        end loop;
        Chart(Pos) := (New_Score, New_Item);
    end Insert_Score;

end Score_Charts;
