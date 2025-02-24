tableextension 50220 "Project Extension" extends Job
{
    fields
    {
        field(50200; "Project Framework Code"; Code[20])
        {
            Caption = 'Project Framework Code';
            DataClassification = ToBeClassified;
            TableRelation = "Project Framework".Code where(State = const(Active));
        }
    }
}
