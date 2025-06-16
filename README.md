# Approval_Extension

## Project Overview

This project is a Business Central extension that implements a multi-level approval workflow for purchase orders. It allows organizations to define approval templates, automate the approval process, and track the status and history of each approval workflow.

## Why This Extension Is Useful

- **Automated Approvals:** Streamlines the purchase order approval process, reducing manual intervention and errors.
- **Configurable Templates:** Enables administrators to define approval steps, approvers, and conditions based on amount or other criteria.
- **Audit Trail:** Maintains a detailed log of all approval actions for compliance and review.
- **Integration:** Seamlessly integrates with standard Business Central tables like "Purchase Header" and "User".

## Main Procedure

The main procedure is `CreateApprovalWorkflow(PurchaseNo: Code[20])` in the [`Approval Workflow`](src/Codeunits/ApprovalWorkflow.Codeunit.al) Codeunit. This procedure:

1. **Validates** the purchase order to ensure it is open and eligible for approval.
2. **Creates** a new approval workflow record for the purchase order.
3. **Generates** approval steps from active templates based on the purchase amount.
4. **Creates** an approval entry and links it to the workflow.
5. **Initiates** the approval process by assigning the first approver.

For more details, see [`ApprovalWorkflow.Codeunit.al`](src/Codeunits/ApprovalWorkflow.Codeunit.al).
