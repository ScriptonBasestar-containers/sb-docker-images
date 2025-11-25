# Supabase Self-hosted

Complete self-hosted Supabase stack with all services configured for local development and production deployment.

## Features

- **PostgreSQL 15**: Database with Supabase extensions
- **GoTrue**: Authentication service with email/phone support
- **PostgREST**: Auto-generated REST API
- **Realtime**: WebSocket subscriptions for live updates
- **Storage**: File storage with image transformations
- **Kong**: API Gateway with authentication
- **Studio**: Web-based admin dashboard
- **Edge Functions**: Serverless Deno runtime
- **Analytics**: Logflare log aggregation
- **Vector**: Log collection and routing

## Quick Start

### 1. Copy Environment File

```bash
cp .env.example .env
```

### 2. Generate Secrets

```bash
# Generate JWT secret
openssl rand -base64 32
```

### 3. Generate API Keys

Visit [Supabase API Keys Generator](https://supabase.com/docs/guides/self-hosting#api-keys) and use your JWT secret to generate:
- `ANON_KEY` - Public anonymous key
- `SERVICE_ROLE_KEY` - Service role key (keep secret!)

Update these values in your `.env` file.

### 4. Start Services

```bash
make up
# or
docker compose up -d
```

### 5. Access Dashboard

- **Studio Dashboard**: http://localhost:3000
- **API Gateway**: http://localhost:8000

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Kong (API Gateway)                      │
│                        Port 8000/8443                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
    ┌─────────────────┼─────────────────┐
    │                 │                 │
    ▼                 ▼                 ▼
┌────────┐    ┌────────────┐    ┌────────────┐
│GoTrue  │    │ PostgREST  │    │  Realtime  │
│(Auth)  │    │ (REST API) │    │(WebSocket) │
│  9999  │    │    3000    │    │    4000    │
└────┬───┘    └─────┬──────┘    └─────┬──────┘
     │              │                 │
     └──────────────┼─────────────────┘
                    │
                    ▼
          ┌─────────────────┐
          │   PostgreSQL    │
          │   Port 5432     │
          └─────────────────┘
```

## Services

| Service | Image | Port | Description |
|---------|-------|------|-------------|
| db | supabase/postgres:15.8.1.085 | 5432 | PostgreSQL database |
| kong | kong:2.8.1 | 8000, 8443 | API Gateway |
| auth | supabase/gotrue:v2.182.1 | 9999 | Authentication |
| rest | postgrest/postgrest:v13.0.7 | - | REST API |
| realtime | supabase/realtime:v2.63.0 | 4000 | WebSocket |
| storage | supabase/storage-api:v1.29.0 | 5000 | File storage |
| imgproxy | darthsim/imgproxy:v3.8.0 | 5001 | Image transformation |
| meta | supabase/postgres-meta:v0.93.1 | 8080 | DB metadata API |
| studio | supabase/studio:2025.11.10 | 3000 | Admin dashboard |
| analytics | supabase/logflare:1.22.6 | 4000 | Log aggregation |
| vector | timberio/vector:0.28.1-alpine | 9001 | Log collection |
| functions | supabase/edge-runtime:v1.69.23 | - | Edge functions |

## API Endpoints

All endpoints are accessed through Kong API Gateway at `http://localhost:8000`:

| Endpoint | Description |
|----------|-------------|
| `/rest/v1/` | PostgREST API |
| `/auth/v1/` | GoTrue authentication |
| `/storage/v1/` | File storage |
| `/realtime/v1/` | WebSocket connections |
| `/functions/v1/` | Edge functions |
| `/graphql/v1` | GraphQL API |

## Usage

### Make Commands

```bash
make help          # Show all commands
make up            # Start all services
make down          # Stop all services
make logs          # View logs
make status        # Check service status
make db-shell      # Open database shell
make db-backup     # Backup database
make secrets       # Generate new secrets
make urls          # Show service URLs
```

### Database Access

```bash
# Connect via psql
make db-shell

# Or directly
docker compose exec db psql -U postgres
```

### API Authentication

Include the `apikey` header in requests:

```bash
# Anonymous request
curl -H "apikey: YOUR_ANON_KEY" \
  http://localhost:8000/rest/v1/your_table

# Authenticated request
curl -H "apikey: YOUR_ANON_KEY" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  http://localhost:8000/rest/v1/your_table
```

### Edge Functions

Place your Deno functions in `volumes/functions/`:

```typescript
// volumes/functions/hello/index.ts
Deno.serve(async (req) => {
  return new Response(
    JSON.stringify({ message: "Hello from Edge Functions!" }),
    { headers: { "Content-Type": "application/json" } },
  )
})
```

## Configuration

### Email (SMTP)

Configure email settings in `.env`:

```env
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=your-username
SMTP_PASS=your-password
SMTP_SENDER_NAME=Your App
```

### S3 Storage

For S3-compatible storage:

```env
STORAGE_BACKEND=s3
GLOBAL_S3_BUCKET=your-bucket
AWS_DEFAULT_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
```

### External Database

To use an external PostgreSQL:

```env
POSTGRES_HOST=your-db-host
POSTGRES_PORT=5432
POSTGRES_DB=postgres
POSTGRES_PASSWORD=your-password
```

## Production Considerations

### Security Checklist

- [ ] Change all default passwords in `.env`
- [ ] Generate strong JWT secret (32+ characters)
- [ ] Generate new API keys
- [ ] Configure HTTPS with valid certificates
- [ ] Restrict database access
- [ ] Enable rate limiting in Kong
- [ ] Set up backup strategy
- [ ] Configure monitoring and alerts

### Scaling

For production workloads:

1. Use managed PostgreSQL (RDS, Cloud SQL, etc.)
2. Enable connection pooling (Supavisor)
3. Use S3-compatible storage
4. Set up load balancing for Kong
5. Configure horizontal scaling for Realtime

### Backup

```bash
# Manual backup
make db-backup

# Automated backups (cron example)
0 2 * * * cd /path/to/supabase && make db-backup
```

## Troubleshooting

### Services not starting

```bash
# Check service status
make status

# View logs
make logs

# Check specific service
docker compose logs auth
```

### Database connection issues

```bash
# Verify database is running
docker compose ps db

# Check database logs
make logs-db

# Test connection
docker compose exec db pg_isready -U postgres
```

### API returning 401

1. Verify API keys in `.env`
2. Check Kong configuration
3. Ensure JWT secret matches across services

## Links

- [Supabase Documentation](https://supabase.com/docs)
- [Self-hosting Guide](https://supabase.com/docs/guides/self-hosting)
- [API Keys Generator](https://supabase.com/docs/guides/self-hosting#api-keys)
- [GitHub Repository](https://github.com/supabase/supabase)

## License

This configuration is based on the official Supabase Docker setup.
See [Supabase License](https://github.com/supabase/supabase/blob/master/LICENSE) for details.
