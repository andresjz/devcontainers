#!/bin/bash
# Fix Docker socket permissions for all platforms
# Works on: Mac Docker Desktop, Windows Docker Desktop, Linux

set -e

if [ -S /var/run/docker.sock ]; then
    echo "🔧 Configuring Docker socket permissions..."
    
    # Get the socket's group ID
    DOCKER_SOCK_GID=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || stat -f '%g' /var/run/docker.sock)
    echo "   Socket GID: $DOCKER_SOCK_GID"
    
    # Update docker group to match socket GID
    sudo groupmod -g "$DOCKER_SOCK_GID" docker 2>/dev/null || echo "   Note: Could not change docker group GID"
    
    # Add vscode user to docker group
    sudo usermod -aG docker vscode 2>/dev/null || echo "   Note: Could not add user to docker group"
    
    # Set socket permissions (fallback for Docker Desktop)
    sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
    
    echo "✅ Docker socket configured!"
    echo ""
else
    echo "⚠️  Docker socket not found at /var/run/docker.sock"
    echo "   Docker-in-Docker may not be available"
fi
