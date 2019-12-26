#resource "aws_ebs_volume" "storage_registry" {
#  availability_zone = var.aws_ebs_avaliable_zone
#  size              = 10
#
#  tags = {
#    Name = "terraform, registry, docker"
#  }
#}

#resource "aws_ebs_snapshot" "storage_registry" {
#  volume_id = aws_ebs_volume.storage_registry.id

#  tags = {
#    Name = "terraform, registry, docker"
#  }
#}
