table 50101 "Mailgun Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Mailgun Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
        }
        field(2; "API Key"; Text[250])
        {
            DataClassification = EndUserIdentifiableInformation;
            Caption = 'API Key';
        }
        field(3; "Domain Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Domain Name';
        }
        field(4; "API Endpoint"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'API Endpoint';
            InitValue = 'https://api.mailgun.net/v3';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
