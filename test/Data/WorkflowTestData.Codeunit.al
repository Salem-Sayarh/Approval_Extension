codeunit 50102 "Workflow Test Data"
{
    procedure CreateApprovalWorkflow(PurchaseNo: Code[20])
    var
        ApprovalWorkflow: Record "Approval Workflow";
        ApprovalTemplate: Record "Approval Workflow Template";
        PurchaseHeader: Record "Purchase Header";
    begin
        //Validate PO
        PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchaseNo);
        if PurchaseHeader.Status <> PurchaseHeader."Status"::Open then
            Error('PO must have "Open" Status');

        //Create Steps from Templates
    end;

    procedure CreateStepFromTemplate(WorkflowID: Integer; POAmount: Decimal);
    var
        ApprovalWorkflow: Record "Approval Workflow";
        ApprovalStep: Record "Approval Workflow Step";
        ApprovalTemplates: Record "Approval Template";
    begin
        //Set Filter for Templates
        ApprovalTemplates.SetRange(IsActive, true);
        ApprovalTemplates.SetFilter(ConditionMinAmount, '<=%1', POAmount);
        ApprovalTemplates.SetCurrentKey(SequenceNo);
        ApprovalTemplates.Ascending(true);

        if ApprovalTemplates.Find() then
            repeat

            until ApprovalTemplates.Next() = 0;
    end;


    local procedure CreateApprovalStep(
        WorkflowID: Integer;
        SequenceNo: Integer;
        ApproverID: Code[20];
        MinAmount: Decimal
    )
    var
        ApprovalStep: Record "Approval Workflow Step";
        User: Record "User";
    begin
        //Validate Approver
        User.SetRange("Full Name", ApproverID);
        if not User.FindFirst() then
            Error('Approver %1 not found', ApproverID);

        //Create Step
        ApprovalStep.Init();
        ApprovalStep.WorkflowID := WorkflowID;
        ApprovalStep.Status := "Approval Step Status"::NotStarted;
        ApprovalStep.ActionDateTime := CurrentDateTime();
        ApprovalStep.SequenceNo := SequenceNo;
        ApprovalStep.ConditionMinAmount := MinAmount;
        ApprovalStep.ApproverID := ApproverID;
        ApprovalStep.Insert(true);
    end;

    procedure CreateDefaultTemplates()
    var
        ApprovalTemplate: Record "Approval Workflow Template";
        i: Integer;
        Index: Integer;
        Amount: Integer;
    begin
        ApprovalTemplate.DeleteAll();
        if not ApprovalTemplate.IsEmpty() then exit;
        Amount := 500;
        Index := 1;

        for i := 1 to 6 do begin
            ApprovalTemplate.Init();
            ApprovalTemplate.TemplateID := Index;
            ApprovalTemplate.SequenceNo := Index;
            ApprovalTemplate.ApproverID := 'ADMIN';
            ApprovalTemplate.ConditionMinAmount := Amount;
            ApprovalTemplate.IsActive := true;
            if i = 4 then
                ApprovalTemplate.IsActive := false;
            ApprovalTemplate.Insert();
            Index := Index + 1;
            Amount := Amount + 2500;
        end;
    end;
}