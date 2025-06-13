page 50104 "Approval Template List Part"
{
    PageType = ListPart;
    SourceTable = "Approval Workflow Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SequenceNo; Rec.SequenceNo) { }
                field(ApproverID; Rec.ApproverID) { }
                field(ConditionMinAmount; Rec.ConditionMinAmount) { }
                field(IsActive; Rec.IsActive) { }
            }
        }
    }
}