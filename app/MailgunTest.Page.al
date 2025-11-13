page 50101 "Mailgun Test"
{
    PageType = Card;
    Caption = 'Send Test Email';
    UsageCategory = Tasks;
    
    layout
    {
        area(Content)
        {
            group(EmailDetails)
            {
                Caption = 'Email Details';
                
                field(FromAddress; FromAddress)
                {
                    ApplicationArea = All;
                    Caption = 'From';
                    ToolTip = 'Specifies the sender email address.';
                }
                field(ToAddress; ToAddress)
                {
                    ApplicationArea = All;
                    Caption = 'To';
                    ToolTip = 'Specifies the recipient email address.';
                }
                field(Subject; Subject)
                {
                    ApplicationArea = All;
                    Caption = 'Subject';
                    ToolTip = 'Specifies the email subject.';
                }
                field(BodyText; BodyText)
                {
                    ApplicationArea = All;
                    Caption = 'Body';
                    MultiLine = true;
                    ToolTip = 'Specifies the email body text.';
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
                Image = SendMail;
                ToolTip = 'Send the email via Mailgun.';
                
                trigger OnAction()
                var
                    MailgunEmail: Codeunit "Mailgun Email";
                begin
                    if FromAddress = '' then
                        Error('From address is required.');
                    if ToAddress = '' then
                        Error('To address is required.');
                    if Subject = '' then
                        Error('Subject is required.');
                    
                    MailgunEmail.SendEmail(FromAddress, ToAddress, Subject, BodyText);
                    Message('Email sent successfully.');
                end;
            }
        }
    }
    
    var
        FromAddress: Text[250];
        ToAddress: Text[250];
        Subject: Text[250];
        BodyText: Text[2048];
}
