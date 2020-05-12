# Create Security Group
resource "aws_security_group" "services" {
  name        = "terraform_services"
  description = "AWS security group for terraform"
  vpc_id      = aws_vpc.vpc_testing.id

  # Input
  ingress {
    from_port   = "1"
    to_port     = "65365"
    protocol    = "TCP"
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