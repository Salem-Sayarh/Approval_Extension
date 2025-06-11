page 50130 "Approval Workflow Test Page"
{
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Approval Workflow";

    layout
    {
        area(Content)
        {
            field(PurchaseOrderNo; SelectedPurchaseNo)
            {
                ApplicationArea = All;
                Caption = 'Purchase Order';
                TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));

                trigger OnValidate()
                begin
                    ValidatePurchaseOrderSelection();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateWorkflowAction)
            {
                Caption = 'Create Workflow';
                Enabled = IsEligibleForWorkflow;
                Image = CreateWorkflow;

                trigger OnAction()
                var
                    ApprovalWorkflow: Record "Approval Workflow";
                begin
                end;
            }
        }
    }
    var
        SelectedPurchaseNo: Code[20];
        IsEligibleForWorkflow: Boolean;
        ShowDetails: Boolean;

    local procedure ValidatePurchaseOrderSelection()
    var
        PurchaseHeader: Record "Purchase Header";
        ApprovalWorkflow: Record "Approval Workflow";
    begin
        // Reset
        IsEligibleForWorkflow := false;
        ShowDetails := false;

        if SelectedPurchaseNo = '' then exit;

        PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, SelectedPurchaseNo);

        if PurchaseHeader.Status <> PurchaseHeader.Status::Open then exit;

        if ApprovalWorkflow.Get(SelectedPurchaseNo) then exit;

        IsEligibleForWorkflow := true;
    end;

}