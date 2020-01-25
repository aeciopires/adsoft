#! /bin/bash
# Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
sudo usermod -aG docker ubuntu;

# Install Docker Compose
COMPOSE_VERSION=1.25.0
sudo curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
sudo chmod 777 /usr/bin/docker-compose

# Prepare Docker workspace
sudo mkdir /docker
sudo mount /dev/xvdf1 /docker

# Install Git
sudo apt-get update -y
sudo apt-get install -y git

# Get Apps
git clone https://github.com/aeciopires/adsoft
sudo mkdir -p /docker/adsoft/db_crud_api
sudo mkdir -p /docker/adsoft/db_app_nodejs

cd adsoft/app_nodejs
docker-compose up -d --build
cd ../app_python
docker-compose up -d --build
cd ../app_crud_api
docker-compose up -d --build

# Install Node Exporter
curl -sSL https://cloudesire.github.io/node-exporter-installer/install.sh | sudo sh

# Install cAdvisor
docker run -d --restart=always \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  gcr.io/google-containers/cadvisor:latest