#!/bin/bash
set -euo pipefail

# Set up apt repositories
echo "==> Installing repo bootstrap packages..."
apt update
apt install -y --no-install-recommends ca-certificates curl gnupg

echo "==> Configuring Docker apt repository..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
. /etc/os-release
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $VERSION_CODENAME stable" > /etc/apt/sources.list.d/docker.list

# Install all dependencies
echo "==> Installing dependencies via apt..."
apt update
apt install -y --no-install-recommends \
    curl \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    git \
    jq \
    nodejs \
    npm \
    ripgrep \
    less \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    yq
