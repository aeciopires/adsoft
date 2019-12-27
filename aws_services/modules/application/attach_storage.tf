resource "aws_volume_attachment" "storage_registry" {
  device_name  = "/dev/xvdf"
#  volume_id    = aws_ebs_volume.storage_registry.id
  volume_id    = var.ebs_disk_registry
  instance_id  = aws_instance.registry.id
  force_detach = true
  # Not Work :-(
  # skip_destroy = true
}

resource "aws_volume_attachment" "storage_monitoring" {
  device_name  = "/dev/xvdf"
#  volume_id    = aws_ebs_volume.storage_monitoring.id
  volume_id    = var.ebs_disk_monitoring
  instance_id  = aws_instance.monitoring.id
  force_detach = true
}

resource "aws_volume_attachment" "storage_loki" {
  device_name  = "/dev/xvdf"
#  volume_id    = aws_ebs_volume.storage_loki.id
  volume_id    = var.ebs_disk_loki
  instance_id  = aws_instance.loki.id
  force_detach = true
}