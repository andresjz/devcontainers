FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for pyenv and nvm
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    sudo \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    ca-certificates \
    unzip \
    postgresql-client \
    zsh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && rm -rf aws awscliv2.zip

# Set up a non-root user (optional but recommended)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir -p /etc/sudoers.d \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Switch to non-root user
USER $USERNAME

# Install pyenv for the non-root user
ENV PYENV_ROOT="/home/$USERNAME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"
RUN curl https://pyenv.run | bash

# Install nvm for the non-root user
ENV NVM_DIR="/home/$USERNAME/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Set up user's bashrc for pyenv and nvm
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /home/$USERNAME/.bashrc \
    && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/$USERNAME/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> /home/$USERNAME/.bashrc \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> /home/$USERNAME/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/$USERNAME/.bashrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \\. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /home/$USERNAME/.bashrc

# Add environment variables to make sure they persist
ENV PYENV_ROOT="/home/$USERNAME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"
ENV NVM_DIR="/home/$USERNAME/.nvm"

# Fix permissions for the user's home directory and tools
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.pyenv \
    && sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.nvm

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set Zsh as default shell
RUN sudo chsh -s $(which zsh) $USERNAME

# Configure Zsh with pyenv and nvm
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /home/$USERNAME/.zshrc \
    && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/$USERNAME/.zshrc \
    && echo 'eval "$(pyenv init -)"' >> /home/$USERNAME/.zshrc \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> /home/$USERNAME/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/$USERNAME/.zshrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /home/$USERNAME/.zshrc
