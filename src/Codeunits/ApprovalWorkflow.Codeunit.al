codeunit 50103 "Approval Workflow"
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

        // Create steps from templates
        CreateStepFromTemplate(ApprovalWorkflow.WorkflowID, PurchaseHeader.Amount);

        // Create approval entry
        CreateApprovalEntry(ApprovalWorkflow);
    end;

    procedure CreateStepFromTemplate(WorkflowID: Integer; POAmount: Decimal);
    var
        ApprovalWorkflow: Record "Approval Workflow";
        ApprovalStep: Record "Approval Workflow Step";
        ApprovalTemplates: Record "Approval Workflow Template";
    begin
        //Set Filter for Templates
        ApprovalTemplates.SetRange(IsActive, true);
        ApprovalTemplates.SetFilter(ConditionMinAmount, '<=%1', POAmount);
        ApprovalTemplates.SetCurrentKey(SequenceNo);
        ApprovalTemplates.Ascending(true);

        if ApprovalTemplates.Find() then
            repeat
                CreateApprovalStep(
                    WorkflowID,
                    ApprovalTemplates.SequenceNo,
                    ApprovalTemplates.ApproverID,
                    ApprovalTemplates.ConditionMinAmount,
                    ApprovalWorkflow.ApprovalEntryID
                );
            until ApprovalTemplates.Next() = 0;
    end;


    local procedure CreateApprovalStep(
        WorkflowID: Integer;
        SequenceNo: Integer;
        ApproverID: Code[20];
        MinAmount: Decimal;
        ApprovalEntry: Integer
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
        ApprovalStep.ApprovalEntryID := ApprovalEntry;
        ApprovalStep.Insert(true);
    end;

    procedure CreateApprovalEntry(ApprovalWorkflow: Record "Approval Workflow")
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
    begin
        ApprovalEntry.Init();
        ApprovalEntry."Table ID" := Database::"Purchase Header";
        ApprovalEntry."Document Type" := ApprovalEntry."Document Type"::Order;
        ApprovalEntry."Document No." := ApprovalWorkflow.DocumentNo;
        ApprovalEntry."Approver ID" := GetFirstApprover(ApprovalWorkflow.WorkflowID);
        ApprovalEntry.Status := ApprovalEntry.Status::Open;
        ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
        ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::Approver;
        ApprovalEntry.Insert(true);

        // Link to workflow
        ApprovalWorkflow.ApprovalEntryID := ApprovalEntry."Entry No.";
        ApprovalWorkflow.Modify();

        // Send for approval
        ApprovalMgmt.ApproveApprovalRequests(ApprovalEntry);
    end;

    procedure GetFirstApprover(WorkflowID: Integer): Code[20]
    var
        ApprovalStep: Record "Approval Workflow Step";
    begin
        ApprovalStep.SetRange(WorkflowID, WorkflowID);
        ApprovalStep.SetCurrentKey(SequenceNo);
        ApprovalStep.Ascending(true);
        if ApprovalStep.FindFirst() then
            exit(ApprovalStep.ApproverID);
    end;
}