------------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
------------------------------------------------------------------------
generic
    type Score_Type is digits <>;
    type Item_Type is private;
package Score_Charts is

    type Score_Record_T is record
        Score: Score_Type := Score_Type'First;
        Item: Item_Type;
    end record;    

    type Score_Chart_T is array(Positive range <>) of Score_Record_T;

    procedure Insert_Score(Chart: in out Score_Chart_T;
        New_Score: in Score_Type;
        New_Item: in Item_Type);

end Score_Charts;
