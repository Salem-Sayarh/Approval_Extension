page 50102 "Approval Steps Test Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Approval Workflow Step";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(StepID; Rec.StepID) { }
                field(ApproverID; Rec.ApproverID) { }
                field(Status; Rec.Status) { }
            }
        }
    }
}