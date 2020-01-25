output "security_group" {
  value       = aws_security_group.services.id
  description = "Id of security Group"
}

output "registry_ip_private" {
  value       = join(", ", aws_instance.registry.*.private_ip)
  description = "Private IP instance"
}

output "registry_ip_public" {
  value       = join(", ", aws_instance.registry.*.public_ip)
  description = "Public IP instance"
}

output "registry_instance_name" {
  value       = join(", ", aws_instance.registry.*.tags.Name)
  description = "Name instance"
}

output "registry_instance_id" {
  value       = join(", ", aws_instance.registry.*.id)
  description = "ID instance"
}

output "loki_ip_private" {
  value       = join(", ", aws_instance.loki.*.private_ip)
  description = "Private IP instance"
}

output "loki_ip_public" {
  value       = join(", ", aws_instance.loki.*.public_ip)
  description = "Public IP instance"
}

output "loki_instance_name" {
  value       = join(", ", aws_instance.loki.*.tags.Name)
  description = "Name instance"
}

output "loki_instance_id" {
  value       = join(", ", aws_instance.loki.*.id)
  description = "ID instance"
}

output "monitoring_ip_private" {
  value       = join(", ", aws_instance.monitoring.*.private_ip)
  description = "Private IP instance"
}

output "monitoring_ip_public" {
  value       = join(", ", aws_instance.monitoring.*.public_ip)
  description = "Public IP instance"
}

output "monitoring_instance_name" {
  value       = join(", ", aws_instance.monitoring.*.tags.Name)
  description = "Name instance"
}

output "monitoring_instance_id" {
  value       = join(", ", aws_instance.monitoring.*.id)
  description = "ID instance"
}

output "apps_ip_private" {
  value       = join(", ", aws_instance.apps.*.private_ip)
  description = "Private IP instance"
}

output "apps_ip_public" {
  value       = join(", ", aws_instance.apps.*.public_ip)
  description = "Public IP instance"
}

output "apps_instance_name" {
  value       = join(", ", aws_instance.apps.*.tags.Name)
  description = "Name instance"
}

output "apps_instance_id" {
  value       = join(", ", aws_instance.apps.*.id)
  description = "ID instance"
}
