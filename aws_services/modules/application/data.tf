# Receive latest version Ubuntu 18.04
# reference: https://www.terraform.io/docs/providers/aws/r/instance.html
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

    filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["ubuntu*18.04-amd64-server-*"]
  }

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
  # https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
  # example: aws ec2 describe-images --filters "Name=name,Values=ubuntu"
}

# Retrieve the list of availability zones
data "aws_availability_zones" "available" {
  state = "available"
}