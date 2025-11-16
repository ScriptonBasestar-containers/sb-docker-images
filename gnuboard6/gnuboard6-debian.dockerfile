FROM python:3.11-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get update -y
# RUN apt-get install -y python3-pip python3-dev build-essential
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git default-libmysqlclient-dev pkg-config

WORKDIR /app

# Clone Gnuboard6 repository
RUN git clone https://github.com/gnuboard/g6.git . && \
    rm -rf .git

RUN python -m pip install --no-cache-dir --upgrade pip
RUN python -m pip install --no-cache-dir -r requirements.txt

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
