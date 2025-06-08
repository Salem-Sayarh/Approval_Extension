table 50102 "Approval History"     // This table is used to store the history of approval actions taken on purchase orders.
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; HistoryEntryID; Integer)
        {
            Caption = 'History Entry ID';
            AutoIncrement = true;
            DataClassification = ToBeClassified;

        }
        field(2; ApprovalHeaderID; Integer)
        {
            Caption = 'Approval Header No.';
            TableRelation = "Approval Header"."ApprovalHeaderID";
            DataClassification = ToBeClassified;
        }
        field(3; SequenceNo; Integer)
        {
            Caption = 'Step No.';
            DataClassification = ToBeClassified;
        }
        field(4; ActionTaken; Enum "Action Taken")
        {
            Caption = 'Action Taken';
            DataClassification = ToBeClassified;
        }
        field(5; ActionActorID; Code[20])
        {
            Caption = 'Action Actor Code';
            TableRelation = User;
            DataClassification = SystemMetadata;
        }
        field(6; ActionDateTime; DateTime)
        {
            Caption = 'Action Date/Time';
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
        key(PrimaryKey; HistoryEntryID)
        {
            Clustered = true;
        }
        key(ApprovalHeaderIdx; ApprovalHeaderID) // speed lookups when querying 
        {
            Clustered = false;
        }
    }

    fieldgroups
    {
        fieldgroup(Default; "HistoryEntryID", "ApprovalHeaderID", "ActionTaken", "ActionActorID", "ActionDateTime", "Comments")
        {

        }
    }

}