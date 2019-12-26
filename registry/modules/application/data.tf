# Receive latest version Ubuntu 18.04
# reference: https://www.terraform.io/docs/providers/aws/r/instance.html
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
  # https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
  # example: aws ec2 describe-images --filters "Name=name,Values=ubuntu"
  owners = ["099720109477"] # Canonical
}