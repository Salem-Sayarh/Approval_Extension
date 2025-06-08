enum 50104 "Approval Workflow Status"
{
    Extensible = true;

    value(0; Submitted) { }
    value(1; Approved) { }
    value(2; Rejected) { }
    value(3; Resubmitted) { } // Edge Case
    value(4; Delegated) { }  // Edge Case
    value(5; Recalled) { }  // Edge Case
}