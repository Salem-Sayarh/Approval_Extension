enum 50103 "StepStatus"
{
    Caption = 'Step Status';
    Extensible = true;

    value(0; NotStarted) { Caption = 'Not Started'; }
    value(1; Pending) { Caption = 'Pending'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Rejected) { Caption = 'Rejected '; }
}