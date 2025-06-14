#!/bin/bash
set -e

# Create secret file if it doesn't exist
if [ ! -f "/app/data/.secret" ]; then
    echo "Generating secret file..."
    devpi-gen-secret > /app/data/.secret
fi

# Initialize devpi server if not already initialized
if [ ! -d "/app/data/.nodeinfo" ]; then
    echo "Initializing devpi server..."
    devpi-init --serverdir=/app/data
fi

# Start devpi server with web interface
echo "Starting devpi server with web interface..."
