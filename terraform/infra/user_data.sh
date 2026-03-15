#!/bin/bash

# Update packages
sudo apt update -y

# Install Docker
sudo apt install -y docker.io

# Install Docker Compose
sudo apt install -y docker-compose

# Install Git
sudo apt install -y git

# Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Allow ubuntu user to run docker
sudo usermod -aG docker ubuntu