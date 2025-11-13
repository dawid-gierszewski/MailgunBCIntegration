codeunit 50100 "Mailgun Setup Mgt."
{
    Caption = 'Mailgun Setup Management';
    SingleInstance = true;

    procedure EnsureSetupExists()
    var
        Setup: Record "Mailgun Setup";
    begin
        if Setup.Get('MAILGUN') then
            exit;

        Setup.Init();
        Setup."Primary Key" := 'MAILGUN';
        Setup."API Base URL" := 'https://api.mailgun.net';
        Setup.Insert();
    end;

    procedure GetSetup(var Setup: Record "Mailgun Setup")
    begin
        EnsureSetupExists();

        if not Setup.Get('MAILGUN') then
            Error('Mailgun setup record could not be retrieved.');
    end;

    procedure GetApiKey(): Text
    var
        Setup: Record "Mailgun Setup";
    begin
        GetSetup(Setup);

        if Setup."API Key" = '' then
            Error('The Mailgun API key is not configured.');

        exit(Setup."API Key");
    end;

    procedure GetDomain(): Text
    var
        Setup: Record "Mailgun Setup";
    begin
        GetSetup(Setup);

        if Setup."Domain" = '' then
            Error('The Mailgun domain is not configured.');

        exit(Setup."Domain");
    end;

    procedure GetApiBaseUrl(): Text
    var
        Setup: Record "Mailgun Setup";
    begin
        GetSetup(Setup);

        if Setup."API Base URL" = '' then
            Error('The Mailgun API base URL is not configured.');

        exit(Setup."API Base URL");
    end;
}
