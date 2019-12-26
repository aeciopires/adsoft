#! /bin/bash
#Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
sudo usermod -aG docker ubuntu;

# Install Zabbix
sudo mkdir -p /docker/grafana/data;
sudo chown -R 472:472 /docker/grafana/data;
sudo chmod -R 775 /docker/grafana;
docker run -d --name=grafana \
--restart always \
-p 3000:3000 \
-e "GF_INSTALL_PLUGINS=grafana-clock-panel,briangann-gauge-panel,alexanderzobnin-zabbix-app" \
-e "GF_SERVER_PROTOCOL=http" \
-e "GF_SERVER_HTTP_PORT=3000" \
-v /docker/grafana/data:/var/lib/grafana \
grafana/grafana

# Install Prometheus
sudo mkdir -p /docker/prometheus
wget http://aeciopires.com/files/prometheus.yml -O /docker/prometheus/prometheus.yml
docker run -d -p 9090:9090 \
 --name prometheus \
 -v /docker/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
 prom/prometheus