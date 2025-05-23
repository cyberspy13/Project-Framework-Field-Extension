table 50220 "Project Framework"
{
    Caption = 'Project Framework';
    DataClassification = ToBeClassified;
    LookupPageId = "Project Frameworks";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; Owner; Code[50])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Rec.TestField("Customer No.");
            end;
        }
        field(5; CustomerName; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
        }
        field(6; "Internal Reference"; Text[30])
        {
            Caption = 'Internal Reference';
            DataClassification = ToBeClassified;
        }
        field(7; "Customer Reference"; Text[30])
        {
            Caption = 'Customer Reference';
            DataClassification = ToBeClassified;
        }
        field(8; State; Enum "Project Framework Status")
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(9; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("End Date" <> 0D) and ("End Date" < "Start Date") then
                    Error('Start date must not be later than end date for Project Framework %1', Code);
            end;
        }
        field(10; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("End Date" < "Start Date") then
                    Error('End date must not be earlier than start date for Project Framework %1', Code);
            end;
        }
        field(11; Description; Text[1024]) // need to double to check with Consultant, to verify that.
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec.TestField("Customer No.");

    end;
}