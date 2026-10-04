#!/bin/bash

set -e

echo "======================================"
echo " DevOps Real-World Lab Setup"
echo "======================================"

# --------------------------------------------------
# 1. Update system
# --------------------------------------------------

echo "Updating system packages..."

sudo apt update
sudo apt upgrade -y


# --------------------------------------------------
# 2. Install basic tools
# --------------------------------------------------

echo "Installing basic tools..."

sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    vim \
    tree \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https


# --------------------------------------------------
# 3. Install Docker
# --------------------------------------------------

echo "======================================"
echo " Installing Docker..."
echo "======================================"

# Remove conflicting packages if they exist

sudo apt remove -y \
    docker.io \
    docker-doc \
    docker-compose \
    podman-docker \
    containerd \
    runc 2>/dev/null || true


# Add Docker's official GPG key

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL \
    https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc


# Add Docker repository

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# Update package index

sudo apt update


# Install Docker Engine and plugins

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin


# Start Docker

sudo systemctl enable docker
sudo systemctl start docker


# Add current user to Docker group

sudo usermod -aG docker "$USER"


# --------------------------------------------------
# 4. Verify Docker
# --------------------------------------------------

echo "======================================"
echo " Verifying Docker..."
echo "======================================"

sudo docker --version
sudo docker compose version

echo "======================================"
echo " Docker installation completed!"
echo "======================================"


# --------------------------------------------------
# 5. Final message
# --------------------------------------------------

echo ""
echo "======================================"
echo " Basic lab setup completed!"
echo "======================================"

echo "IMPORTANT:"
echo "Log out and log back in before running Docker"
echo "without sudo."

echo ""
echo "Next tools we will add:"
echo "  - kubectl"
echo "  - Minikube"
echo "  - Python"
echo "  - Terraform"
echo "  - Jenkins"
echo "======================================"
