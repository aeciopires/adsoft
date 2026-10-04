#! /bin/bash
# Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
sudo usermod -aG docker ubuntu;

# Docker Compose is installed as a plugin of Docker (docker-compose-plugin) by the get-docker.sh script.
# Use the command 'docker compose'.
# https://docs.docker.com/compose/install/linux/

# Prepare Docker workspace
sudo mkdir /docker

# Install Git
sudo apt update -y
sudo apt install -y git

# Get Apps
git clone https://github.com/aeciopires/adsoft
sudo mkdir -p /docker/adsoft/db_crud_api
sudo mkdir -p /docker/adsoft/db_app_nodejs

cd adsoft/app_nodejs || exit 1
sudo docker compose up -d --build
cd ../app_python || exit 1
sudo docker compose up -d --build
cd ../app_crud_api || exit 1
sudo docker compose up -d --build

# Install Node Exporter (package of Ubuntu, listens on port 9100)
sudo apt install -y prometheus-node-exporter

# Install cAdvisor
# https://github.com/google/cadvisor
sudo docker run -d --restart=always \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8088:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  ghcr.io/google/cadvisor:0.60.6
