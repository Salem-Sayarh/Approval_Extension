codeunit 50103 "Approval Workflow"
{
    // Main procedure to create an approval workflow for a purchase order
    procedure CreateApprovalWorkflow(PurchaseNo: Code[20])
    var
        ApprovalWorkflow: Record "Approval Workflow";
        ApprovalTemplate: Record "Approval Workflow Template";
        PurchaseHeader: Record "Purchase Header";
    begin
        // Validate that the purchase order exists and is open
        PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchaseNo);
        if PurchaseHeader.Status <> PurchaseHeader."Status"::Open then
            Error('PO must have "Open" Status');

        // Create approval steps from active templates based on PO amount
        CreateStepFromTemplate(ApprovalWorkflow.WorkflowID, PurchaseHeader.Amount);

        // Create an approval entry and link it to the workflow
        CreateApprovalEntry(ApprovalWorkflow);
    end;

    // Generates approval steps from active templates for the given workflow and PO amount
    procedure CreateStepFromTemplate(WorkflowID: Integer; POAmount: Decimal);
    var
        ApprovalWorkflow: Record "Approval Workflow";
        ApprovalStep: Record "Approval Workflow Step";
        ApprovalTemplates: Record "Approval Workflow Template";
    begin
        // Filter for active templates applicable to the PO amount
        ApprovalTemplates.SetRange(IsActive, true);
        ApprovalTemplates.SetFilter(ConditionMinAmount, '<=%1', POAmount);
        ApprovalTemplates.SetCurrentKey(SequenceNo);
        ApprovalTemplates.Ascending(true);

        // Create approval steps for each applicable template
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

    // Creates a single approval step for the workflow
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
        // Validate that the approver exists as a user
        User.SetRange("Full Name", ApproverID);
        if not User.FindFirst() then
            Error('Approver %1 not found', ApproverID);

        // Initialize and insert the approval step record
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

    // Creates an approval entry and links it to the workflow, then initiates approval
    procedure CreateApprovalEntry(ApprovalWorkflow: Record "Approval Workflow")
    var
        ApprovalEntry: Record "Approval Entry";
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
    begin
        // Initialize approval entry fields
        ApprovalEntry.Init();
        ApprovalEntry."Table ID" := Database::"Purchase Header";
        ApprovalEntry."Document Type" := ApprovalEntry."Document Type"::Order;
        ApprovalEntry."Document No." := ApprovalWorkflow.DocumentNo;
        ApprovalEntry."Approver ID" := GetFirstApprover(ApprovalWorkflow.WorkflowID);
        ApprovalEntry.Status := ApprovalEntry.Status::Open;
        ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
        ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::Approver;
        ApprovalEntry.Insert(true);

        // Link approval entry to workflow and update workflow record
        ApprovalWorkflow.ApprovalEntryID := ApprovalEntry."Entry No.";
        ApprovalWorkflow.Modify();

        // Send approval request to the first approver
        ApprovalMgmt.ApproveApprovalRequests(ApprovalEntry);
    end;

    // Retrieves the first approver for the workflow based on sequence number
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