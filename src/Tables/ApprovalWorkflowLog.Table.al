table 50106 "Approval Workflow Log"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; LogEntryID; Integer)
        {
            Caption = 'Log Entry ID';
            DataClassification = SystemMetadata;
            AutoIncrement = true;

        }
        field(2; WorkflowID; Integer)
        {
            Caption = '';
            DataClassification = SystemMetadata;

        }
        field(3; StepID; Integer)
        {
            Caption = 'Step ID';
            DataClassification = SystemMetadata;

        }
        field(4; Action; Enum "Approval Action Taken")
        {
            Caption = 'Action Taken';
            DataClassification = SystemMetadata;

        }
        field(5; ActorID; code[20])
        {
            Caption = 'Actor ID';
            DataClassification = EndUserIdentifiableInformation;

        }
        field(6; DateTime; DateTime)
        {
            Caption = 'Date/Time';
            DataClassification = SystemMetadata;

        }
        field(7; Comments; Text[250])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(PK; LogEntryID)
        {
            Clustered = true;
        }
        key(Fk_ApprovalWorkflow; WorkflowID)
        {

        }
        key(Fk_ApprovalWorkflowStep; StepID)
        {

        }
    }

    fieldgroups
    {
    }

}