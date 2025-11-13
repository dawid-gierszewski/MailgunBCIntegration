codeunit 50100 "Mailgun Email"
{
    procedure SendEmail(FromAddress: Text[250]; ToAddress: Text[250]; Subject: Text[250]; BodyText: Text[2048])
    var
        MailgunSetup: Record "Mailgun Setup";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        RequestUrl: Text;
        ResponseText: Text;
        AuthString: Text;
    begin
        if not MailgunSetup.Get('SETUP') then
            Error('Mailgun Setup not configured. Please configure it in Mailgun Setup page.');
        
        if MailgunSetup."API Key" = '' then
            Error('API Key is not configured.');
        
        if MailgunSetup."Domain" = '' then
            Error('Domain is not configured.');
        
        // Build request URL
        RequestUrl := MailgunSetup."API Endpoint";
        if not (RequestUrl.EndsWith('/')) then
            RequestUrl += '/';
        RequestUrl += MailgunSetup."Domain" + '/messages';
        
        // Set Basic Authentication
        AuthString := 'api:' + MailgunSetup."API Key";
        HttpClient.DefaultRequestHeaders().Add('Authorization', 'Basic ' + Base64Encode(AuthString));
        
        // Create form data
        Content.WriteFrom(BuildFormData(FromAddress, ToAddress, Subject, BodyText));
        Content.GetHeaders().Clear();
        Content.GetHeaders().Add('Content-Type', 'application/x-www-form-urlencoded');
        
        // Create request
        HttpRequestMessage.Method('POST');
        HttpRequestMessage.SetRequestUri(RequestUrl);
        HttpRequestMessage.Content(Content);
        
        // Send request
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
            Error('Failed to send HTTP request to Mailgun.');
        
        // Check response
        if not HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseText);
            Error('Mailgun API error: %1 - %2', HttpResponseMessage.HttpStatusCode(), ResponseText);
        end;
    end;
    
    local procedure BuildFormData(FromAddress: Text[250]; ToAddress: Text[250]; Subject: Text[250]; BodyText: Text[2048]): Text
    var
        FormData: Text;
    begin
        FormData := 'from=' + EncodeUrl(FromAddress);
        FormData += '&to=' + EncodeUrl(ToAddress);
        FormData += '&subject=' + EncodeUrl(Subject);
        FormData += '&text=' + EncodeUrl(BodyText);
        exit(FormData);
    end;
    
    local procedure EncodeUrl(InputText: Text): Text
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        exit(TypeHelper.UriEscapeDataString(InputText));
    end;
    
    local procedure Base64Encode(InputText: Text): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
    begin
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(InputText);
        TempBlob.CreateInStream(InStream);
        exit(Base64Convert.ToBase64(InStream));
    end;
}
