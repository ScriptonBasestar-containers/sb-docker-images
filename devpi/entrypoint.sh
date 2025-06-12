#!/bin/bash
set -e

# Initialize devpi server if not already initialized
if [ ! -d "/app/data/.nodeinfo" ]; then
    echo "Initializing devpi server..."
    devpi-init --serverdir=/app/data
fi

# Start devpi server
echo "Starting devpi server..."
exec "$@" 