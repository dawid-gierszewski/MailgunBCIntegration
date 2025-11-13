table 50100 "Mailgun Setup"
{
    Caption = 'Mailgun Setup';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "API Key"; Text[100])
        {
            Caption = 'API Key';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(20; "Domain"; Text[100])
        {
            Caption = 'Domain';
            DataClassification = CustomerContent;
        }
        field(30; "API Endpoint"; Text[250])
        {
            Caption = 'API Endpoint';
            DataClassification = CustomerContent;
            InitValue = 'https://api.mailgun.net/v3/';
        }
    }
    
    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
    
    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'SETUP';
    end;
}
