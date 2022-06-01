pageextension 31106 "Accountant Role Center CZZ" extends "Accountant Role Center"
{
    actions
    {
        addafter("Posted Purchase Credit Memos")
        {
            action(SalesAdvLettersCZZ)
            {
                Caption = 'Sales Advance Letters';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Show sales advance letters.';
                RunObject = Page "Sales Advance Letters CZZ";
                RunPageView = where(Status = const(Closed));
            }
            action(PurchAdvLettersCZZ)
            {
                Caption = 'Purchase Advance Letters';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Show purchase advance letters.';
                RunObject = Page "Purch. Advance Letters CZZ";
                RunPageView = where(Status = const(Closed));
            }
        }
    }
}
