resource "aws_volume_attachment" "storage_registry" {
  device_name  = "/dev/xvdf"
  volume_id    = data.aws_ebs_volume.storage_registry.id
  instance_id  = aws_instance.registry.id
  force_detach = true
  # Not Work :-(
  # https://github.com/terraform-providers/terraform-provider-aws/issues/1017
  # skip_destroy = true
}

resource "aws_volume_attachment" "storage_loki" {
  device_name  = "/dev/xvdf"
  volume_id    = data.aws_ebs_volume.storage_loki.id
  instance_id  = aws_instance.loki.id
  force_detach = true
}

resource "aws_volume_attachment" "storage_monitoring" {
  device_name  = "/dev/xvdf"
  volume_id    = data.aws_ebs_volume.storage_monitoring.id
  instance_id  = aws_instance.monitoring.id
  force_detach = true
}