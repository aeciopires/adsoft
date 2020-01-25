resource "aws_ebs_volume" "storage_registry" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 2
  type              = var.disk_type

  tags = {
    Name = "registry, docker, terraform"
  }
}

resource "aws_ebs_volume" "storage_loki" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 2
  type              = var.disk_type

  tags = {
    Name = "loki, docker, terraform"
  }
}

resource "aws_ebs_volume" "storage_monitoring" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 6
  type              = var.disk_type

  tags = {
    Name = "monitoring, docker, terraform"
  }
}