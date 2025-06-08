enum 50102 "Action Taken"
{
    Caption = 'Action Taken';
    Extensible = true;

    value(0; Submitted) { Caption = 'Submitted'; }
    value(1; Approved) { Caption = 'Approved'; }
    value(2; Rejected) { Caption = 'Rejected'; }
    value(3; Resubmitted) { Caption = 'Resubmitted'; }
}