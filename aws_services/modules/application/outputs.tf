output "security_group" {
    value = aws_security_group.services.id
}

output "registry_ip" {
  value = aws_instance.registry.public_ip
}

output "loki_ip" {
  value = aws_instance.loki.public_ip
}

output "monitoring_ip" {
  value = aws_instance.monitoring.public_ip
}