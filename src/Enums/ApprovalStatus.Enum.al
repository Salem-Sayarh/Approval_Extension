enum 50101 "Approval Status Overall"
{
    Caption = 'Approval Status';
    Extensible = true;

    value(0; Pending) { Caption = 'Pending'; }
    value(1; Approved) { Caption = 'Approved'; }
    value(2; Rejected) { Caption = 'Rejected'; }
}