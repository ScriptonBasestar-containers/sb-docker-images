#!/bin/bash
set -e

# Initialize devpi server if not already initialized
# if [ ! -d "/app/data/.nodeinfo" ]; then
#     echo "Initializing devpi server..."
#     devpi-init --serverdir=/app/data
# fi
if [ ! -f "/app/data/.serverversion" ]; then
  echo "Initializing devpi server..."
  devpi-server --serverdir /app/data --init
else
  echo "Using existing devpi server data"
fi

# Start devpi server with web interface
echo "Starting devpi server with web interface..."
exec "$@"
