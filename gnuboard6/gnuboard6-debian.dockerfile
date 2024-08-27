FROM python:3.9-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get update -y
# RUN apt-get install -y python3-pip python3-dev build-essential
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git

WORKDIR /app
COPY app/. /app/

RUN python -m pip install --no-cache-dir --upgrade pip
RUN python -m pip install --no-cache-dir -r requirements.txt

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
