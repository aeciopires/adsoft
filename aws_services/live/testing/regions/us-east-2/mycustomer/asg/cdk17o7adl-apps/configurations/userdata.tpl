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

# Get Apps
sudo docker run -d -p 80:3000 --restart=always --name kube-pires aeciopires/kube-pires:1.0.0

# Install Node Exporter
curl -sSL https://cloudesire.github.io/node-exporter-installer/install.sh | sudo sh

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
