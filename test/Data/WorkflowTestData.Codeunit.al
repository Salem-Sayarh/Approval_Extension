codeunit 50102 "Workflow Test Data"
{
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