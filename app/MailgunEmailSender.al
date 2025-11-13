codeunit 50100 "Mailgun Email Sender"
{
    procedure SendEmail(FromEmail: Text; ToEmail: Text; Subject: Text; Body: Text): Boolean
    var
        MailgunSetup: Record "Mailgun Setup";
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        AuthText: Text;
        UrlText: Text;
        ResponseText: Text;
    begin
        // Get Mailgun setup
        if not MailgunSetup.Get() then
            Error('Mailgun Setup is missing. Please configure Mailgun Setup first.');

        if MailgunSetup."API Key" = '' then
            Error('API Key is not configured in Mailgun Setup.');

        if MailgunSetup."Domain Name" = '' then
            Error('Domain Name is not configured in Mailgun Setup.');

        // Build URL
        UrlText := MailgunSetup."API Endpoint" + '/' + MailgunSetup."Domain Name" + '/messages';

        // Create content
        Content.WriteFrom('from=' + EncodeUrl(FromEmail) + '&to=' + EncodeUrl(ToEmail) + '&subject=' + EncodeUrl(Subject) + '&text=' + EncodeUrl(Body));
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        // Create request
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(UrlText);
        RequestMessage.Content := Content;

        // Add authentication
        RequestMessage.GetHeaders(Headers);
        AuthText := 'Basic ' + EncodeBase64('api:' + MailgunSetup."API Key");
        Headers.Add('Authorization', AuthText);

        // Send request
        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('Failed to send email. Unable to connect to Mailgun API.');

        // Check response
        if not ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(ResponseText);
            Error('Failed to send email. Status Code: %1. Response: %2', ResponseMessage.HttpStatusCode(), ResponseText);
        end;

        Message('Email sent successfully!');
        exit(true);
    end;

    local procedure EncodeUrl(TextToEncode: Text): Text
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        exit(TypeHelper.UriEscapeDataString(TextToEncode));
    end;

    local procedure EncodeBase64(TextToEncode: Text): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        exit(Base64Convert.ToBase64(TextToEncode));
    end;
}
