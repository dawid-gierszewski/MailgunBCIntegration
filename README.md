# Mailgun Business Central Integration

A simple Business Central extension for sending emails via Mailgun API.

## Features

- Send emails through Mailgun API
- Simple setup page for configuration
- Test page for sending emails
- Compatible with Business Central version 14

## Setup

1. **Configure Mailgun Setup**
   - Search for "Mailgun Setup" in Business Central
   - Enter your Mailgun API Key
   - Enter your Mailgun Domain Name (e.g., mg.yourdomain.com)
   - The API Endpoint is pre-filled with the default Mailgun endpoint

2. **Send Test Email**
   - Search for "Send Email via Mailgun" in Business Central
   - Fill in the required fields:
     - From: sender email address
     - To: recipient email address
     - Subject: email subject
     - Body: email message text
   - Click "Send Email" to send

## API Documentation

This integration uses the Mailgun Messages API:
https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/messages/post-v3--domain-name--messages

## Components

- **Table 50101**: Mailgun Setup - stores configuration
- **Page 50101**: Mailgun Setup - configuration page
- **Codeunit 50100**: Mailgun Email Sender - handles email sending
- **Page 50102**: Send Email via Mailgun - test page for sending emails

## Requirements

- Business Central version 14 or higher
- Valid Mailgun account with API key
- Verified domain in Mailgun

## Limitations

- Only supports basic email sending (from, to, subject, body)
- No attachments support
- No email logging
- No HTML email support (text only)
