#!/bin/bash
set -e

# Fix Docker socket permissions (especially for Docker Desktop on Mac)
if [ -S /var/run/docker.sock ]; then
    echo "🔧 Fixing Docker socket permissions..."
    sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
    echo "✅ Docker socket ready!"
fi

# Execute the command
exec "$@"
