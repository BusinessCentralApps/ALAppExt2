tableextension 11511 "Swiss QR-Bill Company Info." extends "Company Information"
{
    fields
    {
        field(11510; "Swiss QR-Bill IBAN"; Code[50])
        {
            Caption = 'QR-IBAN';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckIBAN("Swiss QR-Bill IBAN");
            end;
        }
    }
}
