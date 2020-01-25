variable "aws_zone" {
  description = "The zone to operate under, if not specified by a given resource. Reference: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html"
  default     = "us-east-2"
}

#-------------------------
# Changes the values default of accord with the necessity
#-------------------------

variable "aws_key_name" {
  description = "Key name."
  default     = "aws-teste"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "adsoft_bucket"
}

variable "aws_key_private_path" {
  description = "Private Key Private path."
  default     = "/home/aws-teste.pem"
}

variable "aws_key_public_path" {
  description = "Private Key Public path."
  default     = "/home/aws-teste.pub"
}

variable "aws_instance_user" {
  description = "Instance user for remote connection."
  default     = "ubuntu"
}

variable "disk_size" {
  description = "AWS EBS disk size in GB"
  default     = 300
}

variable "disk_type" {
  description = "AWS EBS disk type. Reference: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html"
  default     = "gp2"
}

variable "port_ssh_external" {
  description = "Port SSH external."
  default     = 22
}

variable "port_registry_external" {
  description = "Port Registry external."
  default     = 5000
}

variable "port_grafana_external" {
  description = "Port Grafana external."
  default     = 3000
}

variable "port_loki_external" {
  description = "Port Loki external."
  default     = 3100
}

variable "port_prometheus_external" {
  description = "Port Prometheus external."
  default     = 9090
}

variable "port_zabbix_web_external" {
  description = "Port Prometheus external."
  default     = 80
}

variable "port_zabbix_server_external" {
  description = "Port Zabbix Server external."
  default     = 10051
}

variable "port_apps_python_external_01" {
  description = "Port Apps Python external."
  default     = 8001
}

variable "port_apps_python_external_02" {
  description = "Port Apps Python external."
  default     = 8002
}

variable "port_apps_crud_api" {
  description = "Port Apps Crud API."
  default     = 9000
}

variable "port_apps_nodejs" {
  description = "Port Apps NodeJS."
  default     = 8080
}

variable "port_protocol" {
  description = "Protocol of container ports."
  default     = "TCP"
}

variable "vpc_cidr_block" {
  description = "Range of IPv4 address for the VPC."
  default     = "10.0.0.0/16"
}

variable "address_allowed" {
  description = "IP or Net address allowed for remote access."
  default     = "179.159.238.101/32"
}

#variable "ebs_disk_registry" {
#  description = "EBS ID for Storage Registry."
#  default     = "vol-05f3c466a6e57b4f5"
#}

#variable "ebs_disk_monitoring" {
#  description = "EBS ID for Storage Monitoring Tools."
#  default     = "vol-08d3cb4130438be8e"
#}

#variable "ebs_disk_loki" {
#  description = "EBS ID for Storage Loki."
#  default     = "vol-0d4fa441c9aaa03e5"
#}