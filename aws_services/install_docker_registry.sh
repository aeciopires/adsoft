#! /bin/bash
# Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
sudo usermod -aG docker ubuntu;

# Install Registry
sudo mkdir -p /docker/registry;
docker run -d -p 5000:5000 --restart always --name registry -v /docker/registry:/var/lib/registry registry:2