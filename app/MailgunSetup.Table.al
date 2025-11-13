table 50100 "Mailgun Setup"
{
    Caption = 'Mailgun Setup';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "API Key"; Text[250])
        {
            Caption = 'API Key';
            DataClassification = SensitivePersonalData;
        }
        field(3; "Domain"; Text[100])
        {
            Caption = 'Domain';
            DataClassification = CustomerContent;
        }
        field(4; "API Base URL"; Text[250])
        {
            Caption = 'API Base URL';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'MAILGUN';

        if "API Base URL" = '' then
            "API Base URL" := 'https://api.mailgun.net';
    end;

    trigger OnModify()
    begin
        if "Primary Key" <> 'MAILGUN' then
            Error('The primary key value must remain MAILGUN.');
    end;
}
