output "security_group" {
    value = aws_security_group.services.id
}

output "registry_ip_private" {
  value = join(", ", aws_instance.registry.*.private_ip)
}

output "registry_ip_public" {
  value = join(", ", aws_instance.registry.*.public_ip)
}

output "registry_instance_name" {
  value = join(", ", aws_instance.registry.*.tags.Name)
}

output "registry_instance_id" {
  value = join(", ", aws_instance.registry.*.id)
}

output "loki_ip_private" {
  value = join(", ", aws_instance.loki.*.private_ip)
}

output "loki_ip_public" {
  value = join(", ", aws_instance.loki.*.public_ip)
}

output "loki_instance_name" {
  value = join(", ", aws_instance.loki.*.tags.Name)
}

output "loki_instance_id" {
  value = join(", ", aws_instance.loki.*.id)
}

output "monitoring_ip_private" {
  value = join(", ", aws_instance.monitoring.*.private_ip)
}

output "monitoring_ip_public" {
  value = join(", ", aws_instance.monitoring.*.public_ip)
}

output "monitoring_instance_name" {
  value = join(", ", aws_instance.monitoring.*.tags.Name)
}

output "monitoring_instance_id" {
  value = join(", ", aws_instance.monitoring.*.id)
}

output "apps_ip_private" {
  value = join(", ", aws_instance.apps.*.private_ip)
}

output "apps_ip_public" {
  value = join(", ", aws_instance.apps.*.public_ip)
}

output "apps_instance_name" {
  value = join(", ", aws_instance.apps.*.tags.Name)
}

output "apps_instance_id" {
  value = join(", ", aws_instance.apps.*.id)
}
