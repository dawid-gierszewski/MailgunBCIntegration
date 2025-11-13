codeunit 50101 "Mailgun Email Service"
{
    Caption = 'Mailgun Email Service';

    procedure SendPlainTextMessage(FromAddress: Text; ToAddress: Text; Subject: Text; Body: Text)
    var
        SetupMgt: Codeunit "Mailgun Setup Mgt.";
        ApiKey: Text;
        Domain: Text;
        BaseUrl: Text;
        RequestUrl: Text;
        FormBody: Text;
        HttpClient: HttpClient;
        ClientHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseContent: HttpContent;
        ResponseText: Text;
    begin
        ValidateParameters(FromAddress, ToAddress, Subject, Body);

        ApiKey := SetupMgt.GetApiKey();
        Domain := SetupMgt.GetDomain();
        BaseUrl := SetupMgt.GetApiBaseUrl();
        RequestUrl := BuildRequestUrl(BaseUrl, Domain);
        FormBody := BuildFormBody(FromAddress, ToAddress, Subject, Body);

        ClientHeaders := HttpClient.DefaultRequestHeaders();
        ClientHeaders.Add('Authorization', StrSubstNo('Basic %1', CreateBasicAuthValue(ApiKey)));
        ClientHeaders.Add('Accept', 'application/json');
        ClientHeaders.Add('User-Agent', 'BC-Mailgun-Integration');

        RequestContent.WriteFrom(FormBody);
        ContentHeaders := RequestContent.GetHeaders();
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        if not HttpClient.Post(RequestUrl, RequestContent, ResponseMessage) then
            Error('The HTTP request to Mailgun could not be sent.');

        if not ResponseMessage.IsSuccessStatusCode() then begin
            ResponseContent := ResponseMessage.Content();
            if ResponseContent.ReadAs(ResponseText) then
                Error('Mailgun returned an error (%1 %2): %3',
                  ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase(), ResponseText)
            else
                Error('Mailgun returned an error (%1 %2).',
                  ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());
        end;
    end;

    local procedure ValidateParameters(FromAddress: Text; ToAddress: Text; Subject: Text; Body: Text)
    begin
        if FromAddress = '' then
            Error('The "from" address must be provided.');

        if ToAddress = '' then
            Error('The "to" address must be provided.');

        if Subject = '' then
            Error('The subject must be provided.');

        if Body = '' then
            Error('The message body must be provided.');
    end;

    local procedure BuildRequestUrl(BaseUrl: Text; Domain: Text): Text
    begin
        exit(DelChr(BaseUrl, '>', '/') + '/v3/' + Domain + '/messages');
    end;

    local procedure BuildFormBody(FromAddress: Text; ToAddress: Text; Subject: Text; Body: Text): Text
    begin
        exit(
          StrSubstNo(
            'from=%1&to=%2&subject=%3&text=%4',
            EncodeFormValue(FromAddress),
            EncodeFormValue(ToAddress),
            EncodeFormValue(Subject),
            EncodeFormValue(Body)));
    end;

    local procedure EncodeFormValue(Value: Text): Text
    var
        Index: Integer;
        Character: Char;
        EncodedValue: Text;
    begin
        for Index := 1 to StrLen(Value) do begin
            Character := Value[Index];

            if IsUnreserved(Character) then
                EncodedValue += Format(Character)
            else
                EncodedValue += EncodeReserved(Character);
        end;

        exit(EncodedValue);
    end;

    local procedure IsUnreserved(Character: Char): Boolean
    begin
        if (Character >= 'A') and (Character <= 'Z') then
            exit(true);
        if (Character >= 'a') and (Character <= 'z') then
            exit(true);
        if (Character >= '0') and (Character <= '9') then
            exit(true);

        case Character of
            '-', '_', '.', '~':
                exit(true);
        end;

        exit(false);
    end;

    local procedure EncodeReserved(Character: Char): Text
    var
        Hex: Text;
        HexLength: Integer;
    begin
        if Character = ' ' then
            exit('+');

        Hex := Format(Character, 0, '<Hex>');
        HexLength := StrLen(Hex);

        if HexLength = 1 then
            Hex := '0' + Hex
        else
            if HexLength > 2 then
                Hex := CopyStr(Hex, HexLength - 1, 2);

        exit('%' + Hex);
    end;

    local procedure CreateBasicAuthValue(ApiKey: Text): Text
    var
        TempBlob: Record "Temp Blob" temporary;
        OutStream: OutStream;
        InStream: InStream;
        Base64: Codeunit "Base64 Convert";
        RawValue: Text;
        EncodedValue: Text;
    begin
        RawValue := StrSubstNo('api:%1', ApiKey);

        TempBlob.Blob.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(RawValue, false);
        TempBlob.Blob.CreateInStream(InStream);

        Base64.ToBase64(InStream, EncodedValue);
        exit(EncodedValue);
    end;
}
