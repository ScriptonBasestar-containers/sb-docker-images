# Gnuboard6 - Missing Application Directory

## Problem
The Dockerfile expects an `app/` directory with application code, but it doesn't exist.

## Error Message
```
failed to solve: failed to compute cache key: failed to calculate checksum of ref: "/app": not found
```

## Dockerfile Reference
```dockerfile
WORKDIR /app
COPY app/. /app/
```

## Current Directory Structure
The `gnuboard6/` directory does not contain an `app/` subdirectory with:
- `requirements.txt`
- `main.py` (FastAPI/Uvicorn application)
- Other application files

## Solution Options

### Option 1: Clone Gnuboard6 Repository
```bash
cd gnuboard6
git clone https://github.com/gnuboard/g6 app
```

### Option 2: Create Sample Application
Create a minimal FastAPI application structure:
```bash
mkdir -p app
cat > app/requirements.txt << EOF
fastapi
uvicorn[standard]
mysqlclient
EOF

cat > app/main.py << EOF
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Gnuboard6 Placeholder"}
EOF
```

### Option 3: Update Dockerfile
Modify the Dockerfile to clone the repository during build:
```dockerfile
FROM python:3.9-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y build-essential git

WORKDIR /app

# Clone the repository during build
RUN git clone https://github.com/gnuboard/g6 .

RUN python -m pip install --no-cache-dir --upgrade pip
RUN python -m pip install --no-cache-dir -r requirements.txt

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Status
- Configuration: ✅ Valid compose.yml
- Dockerfile: ⚠️ References non-existent directory
- Application code: ❌ Missing
- Build: ❌ Cannot complete

## Recommendations
1. Check if Gnuboard6 is actually a FastAPI project (it might be Django-based)
2. Clone the actual Gnuboard6 repository
3. Update Dockerfile to match the actual project structure
4. Verify that Gnuboard6 v6 exists and is publicly available

## Notes
- Gnuboard is traditionally a PHP-based CMS
- Gnuboard6 (g6) might be a rewrite in Python, but the repository status is unclear
- The environment variables suggest Django (`DB_ENGINE=django.db.backends.mysql`)
- But the CMD uses Uvicorn (FastAPI/Starlette)
- This inconsistency needs investigation
