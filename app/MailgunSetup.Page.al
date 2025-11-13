page 50100 "Mailgun Setup"
{
    PageType = Card;
    SourceTable = "Mailgun Setup";
    Caption = 'Mailgun Setup';
    UsageCategory = Administration;
    
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
                    ToolTip = 'Specifies the Mailgun API Key.';
                }
                field("Domain"; Rec."Domain")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Mailgun domain (e.g., mg.yourdomain.com).';
                }
                field("API Endpoint"; Rec."API Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Mailgun API endpoint URL.';
                }
            }
        }
    }
    
    trigger OnOpenPage()
    begin
        if not Rec.Get('SETUP') then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
