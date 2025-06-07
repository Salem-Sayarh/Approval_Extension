table 50103 "Approval Template"     // This table is used to store the approval template  information for purchase orders.
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Template ID';
            AutoIncrement = true;

        }
        field(2; SequenceNo; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sequence No.';
            NotBlank = true;
        }
        field(3; ApproverID; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Approver ID';
            NotBlank = true;
        }
        field(4; ConditionMinAmount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Minimal amount';
            NotBlank = true;
        }
        field(5; Description; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(6; IsActive; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Is Active';
            NotBlank = true;
        }

    }

    keys
    {
        key(PrimaryKey; ID)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;


}