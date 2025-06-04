codeunit 50100 "Submit Approval" //NOTE: CreateHeaderRecord
{

    local procedure ValidateCanSubmit(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        ApprovalHeader: Record "Approval Header";
    begin
        //Check if Purchase have Open Status
        if PurchaseHeader.Status <> PurchaseHeader.Status::Open then begin
            exit(false);
            Error('Purchase must be in Open status to submit for approval.');
        end;
        //Check if Purchase have already been submitted
        if IsApprovalSubmitted(PurchaseHeader."No.") then begin
            exit(false);
            Error('Purchase has already been submitted for approval.');
        end;

        //both conditions are met
        exit(true);
    end;

    local procedure IsApprovalSubmitted(PurchaseOrderNo: Code[20]): Boolean
    var
        ApprovalHeader: Record "Approval Header";
    begin
        ApprovalHeader.SetRange(ApprovalHeader.PurchaseOrderNo, PurchaseOrderNo);
        if ApprovalHeader.FindFirst() then
            exit(true);
        exit(false);
    end;

}

