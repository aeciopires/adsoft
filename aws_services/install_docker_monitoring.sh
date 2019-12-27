#! /bin/bash
# Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
sudo usermod -aG docker ubuntu;

# Prepare Docker workspace
sudo mkdir /docker
sudo mount /dev/xvdf1 /docker

# Install Prometheus
sudo mkdir -p /docker/prometheus
wget http://aeciopires.com/files/prometheus.yml -O /docker/prometheus/prometheus.yml
docker run -d -p 9090:9090 \
 --name prometheus \
 -v /docker/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
 prom/prometheus

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

# Install Zabbix
sudo mkdir -p /docker/mysql/zabbix/data
# MySQL
docker run -d --name mysql-zabbix \
 --restart always \
 -p 3306:3306 \
 -v /docker/mysql/zabbix/data:/var/lib/mysql \
 -e MYSQL_HOST=172.17.0.1 \
 -e MYSQL_ROOT_PASSWORD=secret \
 -e MYSQL_DATABASE=zabbix \
 -e MYSQL_USER=zabbix \
 -e MYSQL_PASSWORD=zabbix \
 mysql:8 --default-authentication-plugin=mysql_native_password
# Wait 1 minute for create database
sleep 60
# Zabbix Server
VERSAO_MAIOR_ZABBIX=4.4
export VERSAO_MAIOR_ZABBIX
docker run -d --name zabbix-server \
 --restart always \
 -p 10051:10051 \
 -e MYSQL_ROOT_PASSWORD="secret" \
 -e DB_SERVER_HOST="172.17.0.1" \
 -e DB_SERVER_PORT="3306" \
 -e MYSQL_USER="zabbix" \
 -e MYSQL_PASSWORD="zabbix" \
 -e MYSQL_DATABASE="zabbix" \
zabbix/zabbix-server-mysql:ubuntu-$VERSAO_MAIOR_ZABBIX-latest
# Wait 1 minute for populate database
sleep 60
# Zabbix Web
docker run -d --name zabbix-web \
 --restart always \
 -p 80:80 \
 -e DB_SERVER_HOST="172.17.0.1" \
 -e DB_SERVER_PORT="3306" \
 -e MYSQL_USER="zabbix" \
 -e MYSQL_PASSWORD="zabbix" \
 -e MYSQL_DATABASE="zabbix" \
 -e ZBX_SERVER_HOST="172.17.0.1" \
 -e PHP_TZ="America/Sao_Paulo" \
 zabbix/zabbix-web-apache-mysql:ubuntu-$VERSAO_MAIOR_ZABBIX-latest
# Zabbix Agent
docker run -d --name zabbix-agent \
 --net=host \
 --hostname "$(hostname)" \
 --privileged \
 -v /:/rootfs \
 -v /var/run:/var/run \
 --restart always \
 -p 10050:10050 \
 -e ZBX_HOSTNAME="$(hostname)" \
 -e ZBX_SERVER_HOST="172.17.0.1" \
 zabbix/zabbix-agent:ubuntu-$VERSAO_MAIOR_ZABBIX-latest

