#-------------------------
# Changes the values default of accord with the necessity
#-------------------------

variable "aws_key_name" {
  description = "Key name."
  default     = "aws-teste"
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

variable "machine_type" {
  description = "Machine Type."
  default     = "t2.micro"
}

variable "port_ssh_external" {
  description = "Port SSH external."
  default     = 22
}

variable "port_http_external" {
  description = "Port HTTP external."
  default     = 5000
}

variable "port_protocol" {
  description = "Protocol of container ports."
  default     = "TCP"
}

variable "address_allowed" {
  description = "IP or Net address allowed for remote access."
  default     = "179.159.236.209/32"
}