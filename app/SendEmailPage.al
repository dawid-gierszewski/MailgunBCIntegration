page 50102 "Send Email via Mailgun"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Send Email via Mailgun';

    layout
    {
        area(Content)
        {
            group(EmailDetails)
            {
                Caption = 'Email Details';

                field(FromEmail; FromEmail)
                {
                    ApplicationArea = All;
                    Caption = 'From';
                    ToolTip = 'Specifies the sender email address';
                }
                field(ToEmail; ToEmail)
                {
                    ApplicationArea = All;
                    Caption = 'To';
                    ToolTip = 'Specifies the recipient email address';
                }
                field(SubjectText; SubjectText)
                {
                    ApplicationArea = All;
                    Caption = 'Subject';
                    ToolTip = 'Specifies the email subject';
                }
                field(BodyText; BodyText)
                {
                    ApplicationArea = All;
                    Caption = 'Body';
                    MultiLine = true;
                    ToolTip = 'Specifies the email body text';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendEmail)
            {
                ApplicationArea = All;
                Caption = 'Send Email';
                ToolTip = 'Send the email via Mailgun';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    MailgunEmailSender: Codeunit "Mailgun Email Sender";
                begin
                    if FromEmail = '' then
                        Error('From email address is required.');
                    if ToEmail = '' then
                        Error('To email address is required.');
                    if SubjectText = '' then
                        Error('Subject is required.');

                    MailgunEmailSender.SendEmail(FromEmail, ToEmail, SubjectText, BodyText);
                end;
            }
            action(OpenSetup)
            {
                ApplicationArea = All;
                Caption = 'Mailgun Setup';
                ToolTip = 'Open Mailgun Setup page';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    MailgunSetupPage: Page "Mailgun Setup";
                begin
                    MailgunSetupPage.Run();
                end;
            }
        }
    }

    var
        FromEmail: Text[250];
        ToEmail: Text[250];
        SubjectText: Text[250];
        BodyText: Text[1000];
}
