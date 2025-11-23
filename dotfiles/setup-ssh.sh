#!/bin/bash

# SSH Key Setup Script for DevContainers
# This script helps you generate SSH keys and configure them for Git services

set -e

echo "🔑 SSH Key Setup for Git Services"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Function to generate SSH key
generate_key() {
    local service=$1
    local email=$2
    local key_file="$HOME/.ssh/id_ed25519_${service}"
    
    if [ -f "$key_file" ]; then
        echo -e "${YELLOW}⚠️  Key for ${service} already exists at ${key_file}${NC}"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipping ${service}..."
            return
        fi
    fi
    
    echo -e "${BLUE}🔐 Generating SSH key for ${service}...${NC}"
    
    # Use email as comment if provided, otherwise use service name
    local comment="${email:-${service}}"
    ssh-keygen -t ed25519 -C "$comment" -f "$key_file" -N ""
    chmod 600 "$key_file"
    chmod 644 "${key_file}.pub"
    
    echo -e "${GREEN}✅ Key generated: ${key_file}${NC}"
    echo ""
    echo "📋 Public key (copy this to ${service}):"
    echo "----------------------------------------"
    cat "${key_file}.pub"
    echo "----------------------------------------"
    echo ""
}

# Get email for SSH keys (optional)
read -p "Enter your email for SSH keys (optional, press Enter to skip): " email

echo ""
echo "Which services do you want to configure?"
echo "1) GitHub"
echo "2) GitLab"
echo "3) Bitbucket"
echo "4) All of the above"
echo "5) Custom"

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        generate_key "github" "$email"
        ;;
    2)
        generate_key "gitlab" "$email"
        ;;
    3)
        generate_key "bitbucket" "$email"
        ;;
    4)
        generate_key "github" "$email"
        generate_key "gitlab" "$email"
        generate_key "bitbucket" "$email"
        ;;
    5)
        read -p "Enter service name (e.g., mycompany): " service_name
        generate_key "$service_name" "$email"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

# Setup SSH config
echo -e "${BLUE}📝 Setting up SSH config...${NC}"

if [ ! -f ~/.ssh/config ]; then
    echo "Creating SSH config from template..."
    if [ -f /workspace/dotfiles/.ssh-config.template ]; then
        cp /workspace/dotfiles/.ssh-config.template ~/.ssh/config
    else
        cat > ~/.ssh/config << 'EOF'
# SSH Configuration for Git Services

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    AddKeysToAgent yes
    IdentitiesOnly yes

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519_gitlab
    AddKeysToAgent yes
    IdentitiesOnly yes

Host bitbucket.org
    HostName bitbucket.org
    User git
    IdentityFile ~/.ssh/id_ed25519_bitbucket
    AddKeysToAgent yes
    IdentitiesOnly yes

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    Compression yes
EOF
    fi
    chmod 600 ~/.ssh/config
    echo -e "${GREEN}✅ SSH config created${NC}"
else
    echo -e "${YELLOW}⚠️  SSH config already exists at ~/.ssh/config${NC}"
    echo "You may need to manually add your service configuration."
fi

echo ""
echo -e "${GREEN}✅ SSH setup complete!${NC}"
echo ""
echo "📚 Next steps:"
echo "1. Copy the public key(s) shown above to your Git service(s)"
echo "   - GitHub: https://github.com/settings/keys"
echo "   - GitLab: https://gitlab.com/-/profile/keys"
echo "   - Bitbucket: https://bitbucket.org/account/settings/ssh-keys/"
echo ""
echo "2. Test your connection:"
echo "   ssh -T git@github.com"
echo "   ssh -T git@gitlab.com"
echo ""
echo "3. Your SSH keys are stored in: ~/.ssh/"
