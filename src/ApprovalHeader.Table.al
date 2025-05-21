table 50100 "Approval Header"
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
            Caption = 'PersonCode';
            TableRelation = User;
            DataClassification = SystemMetadata;
        }
        field(4; CreatedOn; DateTime)
        {
            Caption = 'Created On';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(5; CurrentStepNo; Integer)
        {
            Caption = 'Current Step No.';
            DataClassification = ToBeClassified;
        }
        field(6; OverallStatus; Enum "Approval Status Overall")
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
        }
        field(7; TotalAmount; Decimal)
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
        }
    }

}