table 50101 "Approval Line"     // This table is used to store the approval line information for purchase orders.
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; ApprovalHeaderID; Integer)
        {
            Caption = 'Approval Header No.';
            TableRelation = "Approval Header"."ApprovalHeaderID";
            DataClassification = ToBeClassified;
        }
        field(2; LineNo; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; ApproverID; Code[20])
        {
            Caption = 'Approver Code';
            TableRelation = User;
            DataClassification = SystemMetadata;
        }
        field(4; ConditionMinAmount; Decimal)
        {
            Caption = 'Condition Min Amount';
            DataClassification = ToBeClassified;
        }

        field(5; SequenceNo; Integer)
        {
            Caption = 'Sequence No.';
            DataClassification = ToBeClassified;
        }
        field(6; ActionTaken; Enum "Approval Status Overall")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(7; ActionDateTime; DateTime)
        {
            Caption = 'Action Date/Time';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PrimaryKey; LineNo)
        {
            Clustered = true;
        }
        key(SeqIdx; ApprovalHeaderID, SequenceNo) // speed lookups when querying 
        {
            Clustered = false;
        }
    }

}