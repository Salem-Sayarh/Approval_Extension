enum 50106 "Approval Action Taken"
{
    Extensible = true;

    value(0; NotStarted) { }
    value(1; Pending) { }
    value(2; Approved) { }
    value(3; Rejected) { }
    value(4; Skipped) { }    // Edge Case
    value(5; Delegated) { } // Edge Case
}