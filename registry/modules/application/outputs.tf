output "security_group" {
    value = join(", ", aws_security_group.registry.*.id)
}

output "registry_ip" {
    value = join(", ", aws_instance.registry.*.public_ip)
}