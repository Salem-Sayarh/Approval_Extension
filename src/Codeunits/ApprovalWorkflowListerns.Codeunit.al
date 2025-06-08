codeunit 50101 "Approval Workflow Listeners"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure HandleApproveRequest(var ApprovalEntry: Record "Approval Entry")
    var
        ApprovalHeader: Record "Approval Header";
        ApprovalLine: Record "Approval Line";
        PurchaseHeader: Record "Purchase Header";
        SubmitApproval: Codeunit "Submit Approval";
        ActionTaken: Enum "Action Taken";
        SequenceNo: Integer;
    begin
        //1) Get the Purchase Order ID
        PurchaseHeader.Get(ApprovalEntry."Record ID to Approve");
        //2) Get the Approval Header to Approve
        ApprovalHeader.Get(PurchaseHeader."No.");
        //3) Update the current Step Line
        SequenceNo := ApprovalHeader.CurrentSequenceNo;
        ApprovalLine.SetRange(ApprovalHeaderID, ApprovalHeader.ApprovalHeaderID);
        ApprovalLine.SetRange(SequenceNo, ApprovalHeader.CurrentSequenceNo);
        if ApprovalLine.FindFirst() then begin
            ApprovalLine.StepStatus := StepStatus::Approved;
            ApprovalLine.ActionDateTime := CurrentDateTime();
            ApprovalLine.Modify();
        end;
        //FIXME: Comment form Approval Entry
        //4) Insert History Rec 
        SubmitApproval.CreateHistoryEntry(
            ApprovalHeader.ApprovalHeaderID, SequenceNo, ActionTaken::Approved, UserId, CurrentDateTime(), 'Request approved')

        //5) Complete or Advance the flow
        //TODO: Initial

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnRejectApprovalRequest, '', false, false)]
    local procedure HandleRejectRequest()
    begin

    end;
}