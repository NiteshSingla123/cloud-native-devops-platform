#!/bin/bash
set -e

# Update packages
apt update -y

# Install dependencies
apt install -y docker.io docker-compose git

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Allow ubuntu user to run docker
usermod -aG docker ubuntu

# Verify installations
docker --version
docker-compose --version
git --version