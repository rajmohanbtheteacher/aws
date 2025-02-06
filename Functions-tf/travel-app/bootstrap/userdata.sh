#!/bin/bash
set -e

# Update system packages
apt update -y && apt upgrade -y

# Install dependencies
apt install -y apt-transport-https ca-certificates curl software-properties-common jq awscli

# Add Docker's official GPG key & repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
apt update -y && apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Retrieve Docker credentials from AWS Secrets Manager
DOCKER_CREDS=$(aws secretsmanager get-secret-value --secret-id docker_credentials --query SecretString --output text | jq -r '.username + ":" + .password' | base64)

# Login to Docker
echo $DOCKER_CREDS | docker login --username your-dockerhub-username --password-stdin

# Pull and run the travel app from Docker Hub
docker pull your-dockerhub-username/travel-app:latest

# Run the container with proper restart policy
docker run -d -p 80:3000 --name travel-app --restart always your-dockerhub-username/travel-app:latest

# Confirm the setup
echo "Docker setup complete. Travel App is running."