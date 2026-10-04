#!/bin/bash

set -e

echo "======================================"
echo " DevOps Real-World Lab Setup"
echo "======================================"


# ==================================================
# 1. UPDATE SYSTEM
# ==================================================

echo "======================================"
echo " Updating system packages..."
echo "======================================"

sudo apt update
sudo apt upgrade -y


# ==================================================
# 2. INSTALL BASIC TOOLS
# ==================================================

echo "======================================"
echo " Installing basic tools..."
echo "======================================"

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


# ==================================================
# 3. INSTALL DOCKER
# ==================================================

echo "======================================"
echo " Installing Docker..."
echo "======================================"

# Remove conflicting Docker packages if present

sudo apt remove -y \
    docker.io \
    docker-doc \
    docker-compose \
    podman-docker \
    containerd \
    runc 2>/dev/null || true


# Add Docker GPG key

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


# Install Docker

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin


# Enable and start Docker

sudo systemctl enable docker
sudo systemctl start docker


# Add current user to Docker group

sudo usermod -aG docker "$USER"


# Verify Docker

echo "======================================"
echo " Verifying Docker..."
echo "======================================"

sudo docker --version
sudo docker compose version

echo "Docker installation completed!"


# ==================================================
# 4. INSTALL KUBECTL
# ==================================================

echo "======================================"
echo " Installing kubectl..."
echo "======================================"


# Install required packages

sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gpg


# Create Kubernetes keyring directory

sudo mkdir -p -m 755 /etc/apt/keyrings


# Add Kubernetes signing key

curl -fsSL \
    https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
    | sudo gpg --dearmor --yes \
    -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


# Set permissions

sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg


# Add Kubernetes repository

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null


# Update package index

sudo apt-get update


# Install kubectl

sudo apt-get install -y kubectl


# Verify kubectl

echo "======================================"
echo " Verifying kubectl..."
echo "======================================"

kubectl version --client

echo "kubectl installation completed!"


# ==================================================
# 5. INSTALL MINIKUBE
# ==================================================

echo "======================================"
echo " Installing Minikube..."
echo "======================================"


# Download latest Minikube binary

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64


# Install Minikube

sudo install minikube-linux-amd64 /usr/local/bin/minikube


# Remove downloaded binary

rm -f minikube-linux-amd64


# Verify Minikube

echo "======================================"
echo " Verifying Minikube..."
echo "======================================"

minikube version

echo "Minikube installation completed!"


# ==================================================
# 6. FINAL MESSAGE
# ==================================================

echo ""
echo "======================================"
echo " DevOps Lab Setup Completed!"
echo "======================================"

echo "Installed:"
echo "  ✓ Basic Linux tools"
echo "  ✓ Docker"
echo "  ✓ Docker Compose"
echo "  ✓ kubectl"
echo "  ✓ Minikube"

echo ""
echo "Next tools to add:"
echo "  - Python"
echo "  - Terraform"
echo "  - Jenkins"

echo ""
echo "IMPORTANT:"
echo "If Docker permission is denied, run:"
echo "  newgrp docker"

echo ""
echo "To start Kubernetes with Minikube:"
echo "  minikube start --driver=docker"

echo "======================================"
