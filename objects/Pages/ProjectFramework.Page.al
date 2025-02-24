page 50220 "Project Frameworks"
{
    ApplicationArea = All;
    Caption = 'Project Frameworks';
    PageType = List;
    SourceTable = "Project Framework";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                    ShowMandatory = true;
                }
                field("Internal Reference"; Rec."Internal Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal Reference field.', Comment = '%';
                }
                field("Customer Reference"; Rec."Customer Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Reference field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
