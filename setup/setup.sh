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

sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gpg


sudo mkdir -p -m 755 /etc/apt/keyrings


# Kubernetes signing key

curl -fsSL \
    https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
    | sudo gpg --dearmor --yes \
    -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg


# Kubernetes repository

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null


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

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

rm -f minikube-linux-amd64


# Verify Minikube

echo "======================================"
echo " Verifying Minikube..."
echo "======================================"

minikube version

echo "Minikube installation completed!"


# ==================================================
# 6. INSTALL PYTHON
# ==================================================

echo "======================================"
echo " Installing Python..."
echo "======================================"

sudo apt update

sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv


# Verify Python

echo "======================================"
echo " Verifying Python..."
echo "======================================"

python3 --version
pip3 --version

echo "Python installation completed!"


# ==================================================
# 7. INSTALL JAVA
# ==================================================

echo "======================================"
echo " Installing Java 17..."
echo "======================================"

sudo apt install -y openjdk-17-jdk


# Verify Java

echo "======================================"
echo " Verifying Java..."
echo "======================================"

java -version
javac -version

echo "Java installation completed!"


# ==================================================
# 8. INSTALL TERRAFORM
# ==================================================

echo "======================================"
echo " Installing Terraform..."
echo "======================================"

# Add HashiCorp GPG key

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL \
    https://apt.releases.hashicorp.com/gpg \
    | sudo gpg --dearmor --yes \
    -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg


sudo chmod 644 /etc/apt/keyrings/hashicorp-archive-keyring.gpg


# Add HashiCorp repository

echo "deb [signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null


# Update package index

sudo apt update


# Install Terraform

sudo apt install -y terraform


# Verify Terraform

echo "======================================"
echo " Verifying Terraform..."
echo "======================================"

terraform version

echo "Terraform installation completed!"


# ==================================================
# 9. INSTALL JENKINS
# ==================================================

echo "======================================"
echo " Installing Jenkins..."
echo "======================================"

# Add Jenkins repository key

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key


# Add Jenkins repository

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null


# Update package index

sudo apt-get update


# Install Jenkins

sudo apt-get install -y jenkins


# Enable and start Jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins


# Verify Jenkins

echo "======================================"
echo " Verifying Jenkins..."
echo "======================================"

sudo systemctl status jenkins --no-pager

echo "Jenkins installation completed!"


# ==================================================
# 10. FINAL MESSAGE
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
echo "  ✓ Python"
echo "  ✓ pip"
echo "  ✓ Python venv"
echo "  ✓ Java 17"
echo "  ✓ Terraform"
echo "  ✓ Jenkins"

echo ""
echo "Useful commands:"
echo ""
echo "Start Kubernetes:"
echo "  minikube start --driver=docker"

echo ""
echo "Check Kubernetes:"
echo "  kubectl get nodes"

echo ""
echo "Check Jenkins:"
echo "  sudo systemctl status jenkins"

echo ""
echo "Jenkins initial password:"
echo "  sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

echo ""
echo "If Docker permission is denied:"
echo "  newgrp docker"

echo "======================================"
