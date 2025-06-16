table 50104 "Approval Workflow"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; WorkflowID; Integer)
        {
            Caption = 'Workflow ID';
            AutoIncrement = true;
            DataClassification = SystemMetadata;

        }
        field(2; DocumentType; Enum "Approval Document Type")
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;

        }
        field(3; DocumentNo; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;

            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order)); // Filter to only PurchaseOrder

            trigger OnValidate()
            var
                PurchaseHeader: Record "Purchase Header";
            begin
                if DocumentNo <> '' then
                    if not PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, DocumentNo) then
                        Error('Purchase Order 1% not found', DocumentNo);
            end;

        }
        field(4; InitiatorID; Code[20])
        {
            Caption = 'Initiator User ID';
            DataClassification = EndUserIdentifiableInformation;

        }
        field(5; CreationDateTime; DateTime)
        {
            Caption = 'Created ON';
            DataClassification = SystemMetadata;

        }
        field(6; CurrentStepSequence; Integer)
        {
            Caption = 'Current Step Sequence';
            DataClassification = SystemMetadata;

        }
        field(7; WorkflowStatus; Enum "Approval Workflow Status")
        {
            Caption = 'Workflow Status';
            DataClassification = SystemMetadata;

        }
        field(8; TotalAmount; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;

        }
        field(9; DueDate; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;

        }
        field(10; ApprovalEntryID; Integer)
        {
            Caption = 'Approval Entry ID';
            DataClassification = SystemMetadata;
            TableRelation = "Approval Entry";
        }

    }

    keys
    {
        key(PK; WorkflowID)
        {
            Clustered = true;
        }
        key(DocumentRef; DocumentNo, DocumentType)
        {
            Clustered = false;
        }
        key(PK_ApprovalEntry; ApprovalEntryID)
        {
            Clustered = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; WorkflowID, DocumentType, DocumentNo, WorkflowStatus)
        {
        }

        fieldgroup(Brick; WorkflowStatus, DocumentNo, TotalAmount, DueDate)
        {
        }
    }

}