# ============================================
# Base DevContainer ZSH Configuration
# ============================================

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh theme - we use Starship instead
ZSH_THEME=""

# Oh My Zsh plugins
plugins=(
    git
    docker
    docker-compose
    terraform
    aws
    kubectl
    npm
    python
    pip
    node
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
    command-not-found
    history-substring-search
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================
# Environment Variables
# ============================================

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# AWS CLI configuration
export AWS_PAGER=""  # Disable pager for AWS CLI output

# Editor
export EDITOR='vim'
export VISUAL='vim'

# History
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# Better directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Autocomplete settings
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Menu selection
zstyle ':completion:*' menu select

# ============================================
# Aliases
# ============================================

# Load custom aliases if they exist
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi

# ============================================
# Starship Prompt
# ============================================

eval "$(starship init zsh)"

# ============================================
# Auto-completion
# ============================================

# GitHub CLI completion
if command -v gh &> /dev/null; then
    eval "$(gh completion -s zsh)"
fi

# Terraform completion
if command -v terraform &> /dev/null; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C /usr/local/bin/terraform terraform
fi

# AWS CLI completion
if command -v aws_completer &> /dev/null; then
    complete -C aws_completer aws
fi

# AWS Profile switcher function
asp() {
    if [ -z "$1" ]; then
        echo "Current AWS Profile: ${AWS_PROFILE:-default}"
        echo "\nAvailable profiles:"
        aws configure list-profiles 2>/dev/null || echo "No profiles configured"
    else
        export AWS_PROFILE="$1"
        export AWS_DEFAULT_PROFILE="$1"
        echo "✓ Switched to AWS Profile: $AWS_PROFILE"
    fi
}

# AWS region switcher function
asr() {
    if [ -z "$1" ]; then
        echo "Current AWS Region: ${AWS_DEFAULT_REGION:-not set}"
    else
        export AWS_DEFAULT_REGION="$1"
        export AWS_REGION="$1"
        echo "✓ Switched to AWS Region: $AWS_DEFAULT_REGION"
    fi
}

# Task completion
if command -v task &> /dev/null; then
    autoload -U +X compinit && compinit
fi

# Key bindings for history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
