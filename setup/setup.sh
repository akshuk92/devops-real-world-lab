#!/bin/bash

set -e

echo "======================================"
echo " DevOps Real-World Lab Setup"
echo "======================================"

echo "Updating system packages..."
sudo apt update

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
    lsb-release

echo "======================================"
echo " Basic setup completed successfully!"
echo "======================================"
