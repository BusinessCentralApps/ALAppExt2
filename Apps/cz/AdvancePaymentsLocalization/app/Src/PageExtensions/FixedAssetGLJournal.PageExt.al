#if not CLEAN19
pageextension 31050 "Fixed Asset G/L Journal CZZ" extends "Fixed Asset G/L Journal"
{
    layout
    {
#pragma warning disable AL0432
        modify(Prepayment)
        {
            Visible = not AdvancePaymentsEnabledCZZ;
        }
        modify("Prepayment Type")
        {
            Visible = not AdvancePaymentsEnabledCZZ;
        }
    }

    actions
    {
        modify("Link Advance Letters")
        {
            Visible = not AdvancePaymentsEnabledCZZ;
        }
        modify("Link Whole Advance Letter")
        {
            Visible = not AdvancePaymentsEnabledCZZ;
        }
        modify("UnLink Linked Advance Letters")
        {
            Visible = not AdvancePaymentsEnabledCZZ;
        }
#pragma warning restore AL0432
    }

    var
        AdvancePaymentsMgtCZZ: Codeunit "Advance Payments Mgt. CZZ";
        AdvancePaymentsEnabledCZZ: Boolean;

    trigger OnOpenPage()
    begin
        AdvancePaymentsEnabledCZZ := AdvancePaymentsMgtCZZ.IsEnabled();
    end;
}

#endif