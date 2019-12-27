#! /bin/bash
# Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
sudo usermod -aG docker ubuntu;

# Prepare Docker workspace
sudo mkdir /docker
sudo mount /dev/xvdf1 /docker

# Install Registry
sudo mkdir -p /docker/registry;
docker run -d -p 5000:5000 --restart=always --name registry -v /docker/registry:/var/lib/registry registry:2

# Install Loki
docker run -d -p 3100:3100 --restart=always --name loki grafana/loki

# Install Node Exporter
docker run -d --restart=always \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter \
  --path.rootfs=/host

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