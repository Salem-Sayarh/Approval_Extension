table 50105 "Approval Workflow Step"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; StepID; Integer)
        {
            Caption = 'Step ID';
            AutoIncrement = true;
            DataClassification = SystemMetadata;

        }
        field(2; WorkflowID; Integer)
        {
            Caption = 'Workflow ID';
            DataClassification = SystemMetadata;

        }
        field(3; SequenceNo; Integer)
        {
            Caption = 'Sequence No.';
            DataClassification = SystemMetadata;

        }
        field(4; ApproverID; Code[20])
        {
            Caption = 'Approver ID';
            DataClassification = EndUserIdentifiableInformation;

        }
        field(5; ConditionMinAmount; Decimal)
        {
            Caption = 'Min Amount';
            DataClassification = CustomerContent;

        }
        field(6; Status; Enum "Approval Step Status")
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;

        }
        field(7; ActionDateTime; DateTime)
        {
            Caption = 'Action Date/time';
            DataClassification = SystemMetadata;

        }
        field(8; ApprovalEntryID; Integer)
        {
            Caption = 'Approval Entry ID';
            DataClassification = SystemMetadata;

        }
    }

    keys
    {
        key(PK; StepID)
        {
            Clustered = true;
        }
        key(FK_ApprovalWorkflow; WorkflowID)
        {
            Clustered = false;
        }
        key(FK_ApprovalEntry; ApprovalEntryID)
        {
            Clustered = false;

        }
        key(SequenceIdx; WorkflowID, SequenceNo)
        {
            Clustered = false;
        }
    }

    fieldgroups
    {
    }

}