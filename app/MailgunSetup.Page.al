page 50102 "Mailgun Setup"
{
    Caption = 'Mailgun Setup';
    PageType = Card;
    SourceTable = "Mailgun Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;
    DelayedInsert = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Mailgun private API key.';
                }
                field("Domain"; Rec."Domain")
                {
                    ApplicationArea = All;
                    ToolTip = 'Set the Mailgun domain that should be used for sending messages.';
                }
                field("API Base URL"; Rec."API Base URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Set the Mailgun API base URL. The default is https://api.mailgun.net.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        SetupMgt: Codeunit "Mailgun Setup Mgt.";
    begin
        SetupMgt.EnsureSetupExists();
        Rec.Get('MAILGUN');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Primary Key" := 'MAILGUN';
    end;
}
