table 50100 "Approval Header"     // This table is used to store the header information for purchase order approvals.
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; ApprovalHeaderID; Integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; PurchaseOrderNo; Code[20])
        {
            Caption = 'Purchase Order No.';
            TableRelation = "Purchase Header"."No.";
            DataClassification = CustomerContent;
        }
        field(3; InitiatorUserID; Code[20])
        {
            Caption = 'Person Code';
            TableRelation = User;
            DataClassification = SystemMetadata;
        }
        field(4; InitialApproverID; Code[20])
        {
            Caption = 'Person Code';
            TableRelation = User;
        }
        field(5; CreationDateTime; DateTime)
        {
            Caption = 'Created On';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(6; CurrentStepNo; Integer)
        {
            Caption = 'Current Step No.';
            DataClassification = ToBeClassified;
        }
        field(7; OverallStatus; Enum "Approval Status Overall")
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
        }
        field(8; TotalAmount; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PrimaryKey; ApprovalHeaderID)
        {
            Clustered = true;
        }
        key(PurchaseOrderIdx; PurchaseOrderNo) // speed lookups when querying 
        {
            Clustered = false;
            Unique = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Default; "ApprovalHeaderID", "PurchaseOrderNo", "InitiatorUserID", "InitialApproverID", "CreationDateTime", "OverallStatus", "TotalAmount") { }
    }

}