output "security_group" {
    value = join(", ", aws_security_group.instance.*.id)
}

output "registry_ip" {
    value = join(", ", aws_instance.registry.*.public_ip)
}