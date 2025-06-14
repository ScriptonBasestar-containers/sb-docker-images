#!/bin/bash
set -e

# Create necessary directories and set permissions
mkdir -p /app/data /app/logs
chown -R devpi:devpi /app/data /app/logs

# Create secret file if it doesn't exist
if [ ! -f "/app/data/.secret" ]; then
    echo "Generating secret file..."
    # SECRET=$(devpi-gen-secret)
    # if [ -z "$SECRET" ]; then
    #     echo "Error: Failed to generate secret"
    #     exit 1
    # fi
    # echo "$SECRET" > /app/data/.secret
    devpi-gen-secret --secretfile /app/data/.secret
    # chown devpi:devpi /app/data/.secret
    # chmod 0600 /app/data/.secret
    echo "Secret file created at /app/data/.secret"
fi

# Check if devpi server is already initialized
if [ ! -d "/app/data/.nodeinfo" ] && [ ! -f "/app/data/.serverversion" ]; then
    echo "Initializing devpi server..."
    devpi-init --serverdir=/app/data
    # devpi-init --serverdir=/app/data --theme=semantic-ui
else
    echo "Using existing devpi server data"
fi

# Check if theme exists
# EXTRA_ARGS=()
# THEME=semantic-ui
# if [ -f "$THEME_DIR" ]; then
#     echo "📦 Using semantic-ui theme at $THEME_DIR"
#     EXTRA_ARGS+=(--theme=semantic-ui)
# else
#     echo "⚠️  Semantic UI theme directory not found: $THEME_DIR"
# fi

# Run the provided command
echo "Launching: $@"
exec "$@"
# echo "Launching: $@"
# exec "$@"
# 실제 실행
# exec devpi-server \
#     --serverdir=/app/data \
#     --secretfile=/app/data/.secret \
#     "${EXTRA_ARGS[@]}" \
#     "$@"
