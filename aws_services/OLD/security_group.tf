# Create Security Group
resource "aws_security_group" "services" {
  name        = "terraform_services"
  description = "AWS security group for terraform"
  vpc_id      = aws_vpc.vpc_prod.id

  # Input SSH
  ingress {
    from_port   = var.port_ssh_external
    to_port     = var.port_ssh_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Registry
  ingress {
    from_port   = var.port_registry_external
    to_port     = var.port_registry_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Grafana
  ingress {
    from_port   = var.port_grafana_external
    to_port     = var.port_grafana_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Loki
  ingress {
    from_port   = var.port_loki_external
    to_port     = var.port_loki_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Prometheus
  ingress {
    from_port   = var.port_prometheus_external
    to_port     = var.port_prometheus_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Zabbix Web
  ingress {
    from_port   = var.port_zabbix_web_external
    to_port     = var.port_zabbix_web_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Zabbix Server
  ingress {
    from_port   = var.port_zabbix_server_external
    to_port     = var.port_zabbix_server_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Apps_Python
  ingress {
    from_port   = var.port_apps_python_external_01
    to_port     = var.port_apps_python_external_02
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Apps Crud API
  ingress {
    from_port   = var.port_apps_crud_api
    to_port     = var.port_apps_crud_api
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Input Apps NodeJS
  ingress {
    from_port   = var.port_apps_nodejs
    to_port     = var.port_apps_nodejs
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed, "10.0.0.0/16"]
  }

  # Output
  egress {
    from_port   = 0             # any port
    to_port     = 0             # any port
    protocol    = "-1"          # any protocol
    cidr_blocks = ["0.0.0.0/0"] # any destination
  }

  # ICMP Ping 
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "registry, terraform, test, docker, aws, grafana, loki, zabbix, prometheus"
  }
}