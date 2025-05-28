pageextension 50100 "Purchase Order Submit" extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst(Processing)
        {
            action(Submit)
            {
                Caption = 'Submit';
                Image = Action;
                ToolTip = 'Submit the purchase order';
                ApplicationArea = All;
                Enabled = (Rec.Status = Rec.Status::Open);
                trigger OnAction()
                begin
                    // Add your code here
                    Message('Hello World');
                end;
            }
        }
    }

    var
        myInt: Integer;
}