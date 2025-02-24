
pageextension 50220 "Project Card Ext" extends "Job Card"
{
    layout
    {
        addafter("No. of Archived Versions")
        {
            field("Project Framework Code"; Rec."Project Framework Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Project Framework  field';
            }
        }
    }

}
