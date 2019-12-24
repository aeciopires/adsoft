#-------------------------
# Changes the values default of accord with the necessity
#-------------------------

variable "aws_key_name" {
  description = "Key name."
  default     = "aws-teste.pem"
}

variable "aws_connection_type" {
  description = "Connection type."
  default     = "ssh"
}

variable "aws_key_path" {
  description = "Private Key path."
  default     = "/home/deo/"
}

variable "aws_instance_user" {
  description = "Instance user for remote connection."
  default     = "ubuntu"
}

variable "machine_type" {
  description = "Machine Type."
  default     = "t2.micro"
}

# Default: Ubuntu 18.04
variable "operating_system" {
  description = "Operating System."
  default     = "ami-0fb0129cd568fe35f"
}

variable "permission_read_only" {
  description = "Access permission in directory of Docker Host. If false, read and write. If true, read only."
  default     = false
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