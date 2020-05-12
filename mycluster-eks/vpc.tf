# Reference:
# https://github.com/glaucius/aws-terraform
# https://www.terraform.io/docs/providers/aws/d/vpc.html
# https://www.terraform.io/docs/providers/aws/d/subnet.html

# Create VPC
resource "aws_vpc" "vpc_testing" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  #enable_dns_hostnames = true

  tags = {
    Name = "testing, vpc, terraform, aws"
  }
}

# Subnet Public
resource "aws_subnet" "testing_subnet_public1" {
  vpc_id                    = aws_vpc.vpc_testing.id
  cidr_block                = "10.0.1.0/24"
    map_public_ip_on_launch = "true" #it makes this a public subnet
  availability_zone         = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public1, subnet, testing, terraform, aws"
  }
}

# Subnet Private
resource "aws_subnet" "testing_subnet_private1" {
  vpc_id                    = aws_vpc.vpc_testing.id
  cidr_block                = "10.0.50.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
  availability_zone         = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private1, subnet, testing, terraform, aws"
  }
}