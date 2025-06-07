codeunit 50100 "Submit Approval" //NOTE:InitializeFirstStep
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

    local procedure CreateApprovalHeader(PurchaseHeader: Record "Purchase Header"): Record "Approval Header"
    var
        ApprovalHeader: Record "Approval Header";
    begin
        ApprovalHeader.Init();
        ApprovalHeader.PurchaseOrderNo := PurchaseHeader."No.";
        ApprovalHeader.InitiatorUserID := UserId();
        ApprovalHeader.CreationDateTime := CurrentDateTime();
        ApprovalHeader.CurrentStepNo := 1;
        ApprovalHeader.OverallStatus := ApprovalHeader.OverallStatus::Pending;
        ApprovalHeader.TotalAmount := PurchaseHeader.Amount;
        ApprovalHeader.Insert(true);
    end;

    local procedure BuildApprovalLines(
        ApprovalHeader: Record "Approval Header";
        PurchaseHeader: Record "Purchase Header"
    )
    var
        ApprovalTemplate: Record "Approval Template";
        ApprovalLine: Record "Approval Line";
        LineNo: Integer;
    begin
        ApprovalTemplate.SetRange(ApprovalTemplate.IsActive, true);
        repeat
            if PurchaseHeader.Amount < ApprovalTemplate.ConditionMinAmount then;//continue //FIXME continue 
            ApprovalLine.SetRange(ApprovalHeaderID, ApprovalHeader.ApprovalHeaderID);
            if ApprovalLine.Next(-1) <> 0 then
                ApprovalLine.LineNo := ApprovalLine.LineNo + 1
            else
                LineNo := 1;
            ApprovalLine.Init();    // Init new Approval Line
            //Populate fields
            ApprovalLine.ApprovalHeaderID := ApprovalHeader.ApprovalHeaderID;
            ApprovalLine.LineNo := LineNo;
            ApprovalLine.ApproverID := ApprovalTemplate.ApproverID;
            ApprovalLine.ConditionMinAmount := ApprovalTemplate.ConditionMinAmount;
            ApprovalLine.SequenceNo := ApprovalTemplate.SequenceNo;
            ApprovalLine.StepStatus := StepStatus::NotStarted;
            ApprovalLine.ActionDateTime := CurrentDateTime();
            ApprovalLine.Insert(true); // Write in DB
        until ApprovalTemplate.Next() = 0;
    end;

    local procedure CreateHistoryEntry(HeaderId: Integer; StepNo: Integer; ActionTaken: Enum "Action Taken";
    ActionActor: Code[20]; Comments: Text[250])
    var
        ApprovalHistory: Record "Approval History";
    begin
        ApprovalHistory.Init();
        ApprovalHistory.ApprovalHeaderID := HeaderID;
        ApprovalHistory.StepNo := StepNo;
        ApprovalHistory.ActionActorID := ActionActor;
        ApprovalHistory.ActionTaken := ActionTaken;
        ApprovalHistory.ActionDateTime := CurrentDateTime();
        ApprovalHistory.Comments := Comments;
        ApprovalHistory.Insert();
    end;

}

