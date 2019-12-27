#resource "aws_volume_attachment" "storage_registry" {
#  device_name  = "/dev/sdh"
#  volume_id    = aws_ebs_volume.storage_registry.id
#  instance_id  = aws_instance.registry.id
#  
  # Not Work :-(
  # force_detach = true
  # skip_destroy = true
#}

#resource "aws_volume_attachment" "storage_monitoring" {
#  device_name  = "/dev/sdh"
#  volume_id    = aws_ebs_volume.storage_monitoring.id
#  instance_id  = aws_instance.monitoring.id
#}

#resource "aws_volume_attachment" "storage_loki" {
#  device_name  = "/dev/sdh"
#  volume_id    = aws_ebs_volume.storage_loki.id
#  instance_id  = aws_instance.loki.id
#}