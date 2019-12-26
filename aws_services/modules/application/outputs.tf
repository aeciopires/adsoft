output "security_group" {
    value = aws_security_group.services.id
}

output "registry_ip" {
  value = aws_instance.registry.private_ip
}
