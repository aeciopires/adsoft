#resource "aws_ebs_volume" "storage_registry" {
#  availability_zone = data.aws_availability_zones.available.names[0]
#  size              = 2
#  
#  tags = {
#    Name = "terraform, registry, docker"
#  }
#}
#
#resource "aws_ebs_volume" "storage_loki" {
#  availability_zone = data.aws_availability_zones.available.names[0]
#  size              = 2
#  
#  tags = {
#    Name = "terraform, loki, docker"
#  }
#}
#
#resource "aws_ebs_volume" "storage_monitoring" {
#  availability_zone = data.aws_availability_zones.available.names[0]
#  size              = 6
#  
#  tags = {
#    Name = "terraform, monitoring, docker"
#  }
#}