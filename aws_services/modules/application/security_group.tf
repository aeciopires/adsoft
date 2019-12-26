# Create Security Group
resource "aws_security_group" "services" {
  name        = "terraform_services"
  description = "AWS security group for terraform"

  # Input SSH
  ingress {
    from_port   = var.port_ssh_external
    to_port     = var.port_ssh_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed]
  }

  # Input Registry
  ingress {
    from_port   = var.port_registry_external
    to_port     = var.port_registry_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed]
  }

  # Input Grafana
  ingress {
    from_port   = var.port_grafana_external
    to_port     = var.port_grafana_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed]
  }

  # Input Loki
  ingress {
    from_port   = var.port_loki_external
    to_port     = var.port_loki_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed]
  }

  # Input Prometheus
  ingress {
    from_port   = var.port_prometheus_external
    to_port     = var.port_prometheus_external
    protocol    = var.port_protocol
    cidr_blocks = [var.address_allowed]
  }

  # Output
  egress {
      from_port   = 0               # any port
      to_port     = 0               # any port
      protocol    = "-1"            # any protocol
      cidr_blocks = ["0.0.0.0/0"]   # any destination
    }

  tags = {
    Name = "registry, terraform, test, docker, aws, grafana, loki, zabbix, prometheus"
  }
}