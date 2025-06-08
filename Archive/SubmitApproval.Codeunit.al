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
        ApprovalHistory: Record "Approval History";
    begin
        ApprovalHeader.Init();
        ApprovalHeader.PurchaseOrderNo := PurchaseHeader."No.";
        ApprovalHeader.InitiatorUserID := UserId();
        ApprovalHeader.CreationDateTime := CurrentDateTime();
        ApprovalHeader.CurrentSequenceNo := 1;
        ApprovalHeader.OverallStatus := ApprovalHeader.OverallStatus::Pending;
        ApprovalHeader.TotalAmount := PurchaseHeader.Amount;
        ApprovalHeader.Insert(true);
        //Insert history Rec
        CreateHistoryEntry(ApprovalHeader.ApprovalHeaderID, 0, ApprovalHistory.ActionTaken::Submitted, ApprovalHeader.InitiatorUserID, ApprovalHeader.CreationDateTime, 'Approval submitted');

        exit(ApprovalHeader);
    end;

    local procedure BuildApprovalLines(
        ApprovalHeader: Record "Approval Header";
        PurchaseHeader: Record "Purchase Header"
    )
    var
        ApprovalTemplate: Record "Approval Template";
        ApprovalLine: Record "Approval Line";
        ApprovalHistory: Record "Approval History";
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

    procedure CreateHistoryEntry(HeaderId: Integer; StepNo: Integer; ActionTaken: Enum "Action Taken";
    ActionActor: Code[20]; ActionDateTime: DateTime; Comments: Text[250])
    var
        ApprovalHistory: Record "Approval History";
    begin
        ApprovalHistory.Init();
        ApprovalHistory.ApprovalHeaderID := HeaderID;
        ApprovalHistory.SequenceNo := StepNo;
        ApprovalHistory.ActionActorID := ActionActor;
        ApprovalHistory.ActionTaken := ActionTaken;
        ApprovalHistory.ActionDateTime := ActionDateTime;
        ApprovalHistory.Comments := Comments;
        ApprovalHistory.Insert(true);
    end;

    procedure ActivateStep(ApprovalHeader: Record "Approval Header")
    var
        ApprovalLine: Record "Approval Line";
        ApprovalTemplate: Record "Approval Template";
        PurchaseHeader: Record "Purchase Header";
        NextSequenceNo: Integer;
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
    begin
        //GET next SequenceNo
        NextSequenceNo := ApprovalHeader.CurrentSequenceNo;
        // GET current LineNo
        ApprovalLine.SetRange(ApprovalHeaderID, ApprovalHeader.ApprovalHeaderID);
        ApprovalLine.SetRange(SequenceNo, NextSequenceNo);
        if not ApprovalLine.FindFirst() then
            Error('No Approval Line for Sequence 1%', NextSequenceNo);

        // Update The Line
        ApprovalLine.StepStatus := StepStatus::Pending;
        ApprovalLine.ActionDateTime := CurrentDateTime;
        ApprovalLine.Modify();

        //CALL Approvals-Mgmt
        PurchaseHeader.Get(ApprovalHeader.PurchaseOrderNo);
        // Codeunit.Run(ApprovalMgmt, PurchaseHeader,ApprovalLine.ApproverID,)
    end;

}

