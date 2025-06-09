table 50107 "Approval Workflow Template"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; TemplateID; Integer)
        {
            Caption = 'Template ID';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; SequenceNo; Integer)
        {
            Caption = 'Sequence No.';
            DataClassification = SystemMetadata;
        }
        field(3; ApprovalID; Integer)
        {
            Caption = 'Approval ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User;
        }
        field(4; ConditionMinAmount; Decimal)
        {
            Caption = 'Min Amount';
            DataClassification = CustomerContent;
        }
        field(5; IsActive; Boolean)
        {
            Caption = 'Is Active';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; TemplateID)
        {
            Clustered = true;
        }
        key(ActiveTemplate; IsActive, SequenceNo)
        {
        }
    }

    fieldgroups
    {
    }

}