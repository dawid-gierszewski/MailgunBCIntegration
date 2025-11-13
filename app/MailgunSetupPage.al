page 50101 "Mailgun Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Mailgun Setup";
    Caption = 'Mailgun Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Mailgun API Key';
                    ExtendedDatatype = Masked;
                }
                field("Domain Name"; Rec."Domain Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Mailgun Domain Name (e.g., mg.yourdomain.com)';
                }
                field("API Endpoint"; Rec."API Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Mailgun API Endpoint URL';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert();
        end;
    end;
}
