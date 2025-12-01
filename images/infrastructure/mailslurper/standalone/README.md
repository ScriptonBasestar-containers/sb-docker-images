# MailSlurper Standalone - SMTP Mail Testing Server

완전한 독립 실행 가능한 MailSlurper SMTP 메일 테스트 서버 구성입니다.

## Overview

MailSlurper는 로컬 개발 및 테스트를 위한 간단한 SMTP 메일 서버입니다. 실제로 이메일을 발송하지 않고 웹 인터페이스에서 발송된 이메일을 확인할 수 있어, 개발 중인 애플리케이션의 이메일 기능을 안전하게 테스트할 수 있습니다.

### Features

- **SMTP Server**: 애플리케이션에서 발송한 이메일 수신
- **Web UI**: 받은 이메일을 브라우저에서 확인
- **REST API**: 프로그래밍 방식으로 이메일 조회 및 관리
- **No Authentication**: 설정 없이 즉시 사용 가능
- **SQLite Storage**: 경량 데이터베이스로 이메일 저장
- **Development Friendly**: 개발 환경에 최적화

## Quick Start

```bash
# 환경 변수 설정 (선택사항)
cp .env.example .env

# MailSlurper 시작
make up

# Web UI 접속
make web

# API 테스트
make api
```

## Access Information

| Service | URL | Description |
|---------|-----|-------------|
| Web UI | `http://localhost:8085` | Email viewer interface |
| API | `http://localhost:8080` | REST API endpoint |
| SMTP | `localhost:2500` | SMTP server for apps |

## Available Commands

### Service Management

```bash
make up          # Start MailSlurper
make down        # Stop MailSlurper
make restart     # Restart MailSlurper
make logs        # View logs
make ps          # Show running containers
make clean       # Remove all data (destructive)
```

### MailSlurper Operations

```bash
make web         # Open web UI in browser
make api         # Test API connection
make test        # Send test email
```

## Application Configuration

### Rails

```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'localhost',
  port: 2500,
  domain: 'localhost'
}
```

### Django

```python
# settings.py
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'localhost'
EMAIL_PORT = 2500
EMAIL_USE_TLS = False
EMAIL_USE_SSL = False
```

### Flask

```python
# config.py
MAIL_SERVER = 'localhost'
MAIL_PORT = 2500
MAIL_USE_TLS = False
MAIL_USE_SSL = False
MAIL_USERNAME = None
MAIL_PASSWORD = None
```

### Node.js (Nodemailer)

```javascript
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: 'localhost',
  port: 2500,
  secure: false, // No TLS
  tls: {
    rejectUnauthorized: false
  }
});

// Send email
transporter.sendMail({
  from: 'sender@example.com',
  to: 'recipient@example.com',
  subject: 'Test Email',
  text: 'This is a test email',
  html: '<p>This is a <b>test</b> email</p>'
});
```

### PHP

```php
// Configure PHP mail
ini_set('SMTP', 'localhost');
ini_set('smtp_port', '2500');

// Or use PHPMailer
use PHPMailer\PHPMailer\PHPMailer;

$mail = new PHPMailer();
$mail->isSMTP();
$mail->Host = 'localhost';
$mail->Port = 2500;
$mail->SMTPAuth = false;

$mail->setFrom('sender@example.com');
$mail->addAddress('recipient@example.com');
$mail->Subject = 'Test Email';
$mail->Body = 'This is a test email';
$mail->send();
```

### Laravel

```env
# .env
MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=2500
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="noreply@example.com"
MAIL_FROM_NAME="${APP_NAME}"
```

### Go

```go
package main

import (
    "net/smtp"
)

func main() {
    from := "sender@example.com"
    to := []string{"recipient@example.com"}
    msg := []byte("To: recipient@example.com\r\n" +
        "Subject: Test Email\r\n" +
        "\r\n" +
        "This is a test email.\r\n")

    err := smtp.SendMail("localhost:2500", nil, from, to, msg)
    if err != nil {
        panic(err)
    }
}
```

## Docker Compose Integration

### With Your Application

```yaml
services:
  app:
    image: your-app
    environment:
      # Use service name as hostname
      SMTP_HOST: mailslurper
      SMTP_PORT: 2500
    depends_on:
      - mailslurper
    networks:
      - app-network

  mailslurper:
    image: scriptonbasestar/mailslurper:latest
    ports:
      - "2500:2500"
      - "8080:8080"
      - "8085:8085"
    networks:
      - app-network

networks:
  app-network:
```

### WordPress/Joomla/Drupal

```yaml
services:
  cms:
    image: wordpress:latest  # or joomla, drupal
    # ... other config ...
    networks:
      - cms-network

  mailslurper:
    image: scriptonbasestar/mailslurper:latest
    ports:
      - "2500:2500"
      - "8085:8085"
    networks:
      - cms-network

networks:
  cms-network:
```

Then configure SMTP plugin:
- SMTP Host: `mailslurper`
- SMTP Port: `2500`
- Encryption: None
- Authentication: Not required

## API Usage

### List All Emails

```bash
# Get all emails
curl http://localhost:8080/mail

# Pretty print with jq
curl -s http://localhost:8080/mail | jq '.'
```

### Get Specific Email

```bash
# Get email by ID
curl http://localhost:8080/mail/{id}

# Get email details with jq
curl -s http://localhost:8080/mail/{id} | jq '.body'
```

### Delete Emails

```bash
# Delete specific email
curl -X DELETE http://localhost:8080/mail/{id}

# Delete all emails
curl -X DELETE http://localhost:8080/mail
```

### Integration Testing

```python
# Python example
import requests

# Get all emails
response = requests.get('http://localhost:8080/mail')
emails = response.json()

# Find email by subject
test_email = next(
    (e for e in emails if e['subject'] == 'Password Reset'),
    None
)

# Verify email content
assert test_email is not None
assert 'reset_token' in test_email['body']

# Clean up
requests.delete(f"http://localhost:8080/mail/{test_email['id']}")
```

```javascript
// Node.js example
const axios = require('axios');

async function verifyEmail() {
  // Wait for email to arrive
  await new Promise(resolve => setTimeout(resolve, 1000));

  // Get emails
  const response = await axios.get('http://localhost:8080/mail');
  const emails = response.data;

  // Find and verify
  const testEmail = emails.find(e => e.subject === 'Welcome!');
  expect(testEmail).toBeDefined();
  expect(testEmail.to).toContain('user@example.com');

  // Cleanup
  await axios.delete(`http://localhost:8080/mail/${testEmail.id}`);
}
```

## Testing

### Send Test Email via telnet

```bash
telnet localhost 2500

# Then type:
HELO localhost
MAIL FROM: sender@example.com
RCPT TO: recipient@example.com
DATA
Subject: Test Email
From: sender@example.com
To: recipient@example.com

This is a test email.
.
QUIT
```

### Send Test Email via netcat

```bash
echo -e "Subject: Test Email\nFrom: test@example.com\nTo: recipient@example.com\n\nThis is a test." | nc localhost 2500
```

### Send Test Email via Python

```python
import smtplib
from email.mime.text import MIMEText

msg = MIMEText('This is a test email')
msg['Subject'] = 'Test Email'
msg['From'] = 'sender@example.com'
msg['To'] = 'recipient@example.com'

smtp = smtplib.SMTP('localhost', 2500)
smtp.send_message(msg)
smtp.quit()
```

## Use Cases

### 1. User Registration Testing

```yaml
Scenario: Test welcome email
1. User signs up through your app
2. App sends welcome email via MailSlurper
3. Open Web UI to verify email content
4. Check email formatting and links
5. Verify personalization (user name, etc.)
```

### 2. Password Reset Flow

```yaml
Scenario: Test password reset
1. User requests password reset
2. App sends reset email with token
3. Verify email in Web UI
4. Extract reset token from email
5. Test reset link functionality
6. Verify email template rendering
```

### 3. Email Template Development

```yaml
Scenario: Develop and preview templates
1. Create HTML email template
2. Send test email via app
3. View rendered template in Web UI
4. Check responsive design
5. Verify images and styling
6. Test across different email clients
```

### 4. Integration Testing

```yaml
Scenario: Automated email testing
1. Run integration tests
2. Tests trigger email sends
3. API checks for expected emails
4. Verify email content programmatically
5. Clean up test emails via API
```

## Monitoring

### View Logs

```bash
# Real-time logs
make logs

# Last 100 lines
docker compose logs --tail=100 mailslurper
```

### Check Status

```bash
# Container status
make ps

# Port bindings
docker compose ps

# Resource usage
docker stats mailslurper
```

## Troubleshooting

### Cannot Connect to SMTP

```bash
# Check if container is running
make ps

# Verify SMTP port
telnet localhost 2500
# or
nc -zv localhost 2500

# Check logs for errors
make logs

# Restart service
make restart
```

### Emails Not Appearing in Web UI

```bash
# Check if email was received
make logs

# Verify your app's SMTP configuration
# - Host: localhost (or 'mailslurper' in Docker network)
# - Port: 2500
# - TLS: disabled
# - Auth: not required

# Test SMTP directly
echo "test" | nc localhost 2500
```

### Web UI Not Accessible

```bash
# Check port binding
docker compose ps

# Try different browser
# Clear browser cache: Ctrl+Shift+R

# Check if port is in use
netstat -tuln | grep 8085

# Change port in .env if needed
MAILSLURPER_WEB_PORT=8810
```

### API Returns Empty

```bash
# Verify API is working
make api

# Check if emails exist
curl http://localhost:8080/mail | jq 'length'

# Send test email first
make test

# Then check API again
make api
```

### Port Already in Use

```bash
# Find what's using the port
sudo lsof -i :2500
sudo lsof -i :8085

# Change ports in .env
MAILSLURPER_SMTP_PORT=2501
MAILSLURPER_WEB_PORT=8086

# Restart
make down
make up
```

## Data Management

### Clear All Emails

```bash
# Via API
curl -X DELETE http://localhost:8080/mail

# Or restart container (SQLite in-memory)
make restart
```

### Email Retention

MailSlurper stores emails in SQLite. To persist emails across restarts, you would need to mount a volume for the database file. However, for development purposes, ephemeral storage is usually preferred.

## Security Considerations

### Development Only

- **NEVER use in production**
- No authentication or authorization
- No encryption or security features
- Designed for local development only

### Network Isolation

```yaml
# Good: Isolated development network
services:
  mailslurper:
    networks:
      - dev-network
    # No port bindings = only accessible within Docker network

# Bad: Exposed to host network
services:
  mailslurper:
    network_mode: host  # Don't do this
```

### Privacy

- Do NOT use real customer email addresses
- Do NOT test with sensitive information
- Emails are stored unencrypted
- Anyone with access to Web UI can see all emails

### Firewall Rules

```bash
# Block external access (if needed)
sudo ufw deny 2500
sudo ufw deny 8080
sudo ufw deny 8085

# Allow only localhost
sudo ufw allow from 127.0.0.1 to any port 2500
```

## Architecture

```
┌─────────────────────────────┐
│   Your Application          │
│  (Rails, Django, Node, etc) │
└──────────┬──────────────────┘
           │ SMTP (Port 2500)
           ▼
┌─────────────────────────────┐
│     MailSlurper Container   │
│  ┌─────────────────────┐    │
│  │   SMTP Server       │    │
│  │   (Port 2500)       │    │
│  └──────────┬──────────┘    │
│             │                │
│  ┌──────────▼──────────┐    │
│  │   SQLite Database   │    │
│  └──────────┬──────────┘    │
│             │                │
│  ┌──────────▼──────────┐    │
│  │   REST API          │    │
│  │   (Port 8080)       │    │
│  └─────────────────────┘    │
│             │                │
│  ┌──────────▼──────────┐    │
│  │   Web UI            │    │
│  │   (Port 8085)       │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
           │
           ▼
┌─────────────────────────────┐
│   Developer Browser         │
│   http://localhost:8085     │
└─────────────────────────────┘
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MAILSLURPER_SMTP_PORT` | `2500` | SMTP server port |
| `MAILSLURPER_WEB_PORT` | `8085` | Web UI port |
| `MAILSLURPER_API_PORT` | `8080` | REST API port |
| `MAILSLURPER_IMAGE` | `scriptonbasestar/mailslurper:latest` | Docker image |
| `MAILSLURPER_CONTAINER_NAME` | `mailslurper` | Container name |
| `TZ` | `Asia/Seoul` | Timezone |

## Network

| Network | Driver | Description |
|---------|--------|-------------|
| `mail-network` | `bridge` | Mail testing network |

## Alternative Tools

If MailSlurper doesn't meet your needs:

### MailHog
- **URL**: https://github.com/mailhog/MailHog
- **Pros**: Popular, actively maintained, similar features
- **Cons**: Go binary, slightly heavier

### MailCatcher
- **URL**: https://mailcatcher.me/
- **Pros**: Ruby-based, simple UI
- **Cons**: Ruby dependency

### Mailtrap
- **URL**: https://mailtrap.io/
- **Pros**: Cloud-based, advanced features, team collaboration
- **Cons**: Paid service, requires internet

### FakeSMTP
- **URL**: https://github.com/Nilhcem/FakeSMTP
- **Pros**: Java-based, desktop GUI
- **Cons**: No web UI, requires Java

## References

- [MailSlurper GitHub](https://github.com/mailslurper/mailslurper)
- [MailSlurper Wiki](https://github.com/mailslurper/mailslurper/wiki)
- [Configuration Guide](https://github.com/mailslurper/mailslurper/wiki/Configuration-File)
- [Port Guide](../../docs/PORT_STATUS.md)
- [Main README](../README.md)
