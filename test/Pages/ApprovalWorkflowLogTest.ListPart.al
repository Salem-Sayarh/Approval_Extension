page 50103 "Approval Workflow Log Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Approval Workflow Log";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(StepID; Rec.StepID) { }
                field(Action; Rec.Action) { }
                field(ActorID; Rec.ActorID) { }
                field(DateTime; Rec.DateTime) { }
            }
        }
    }
}