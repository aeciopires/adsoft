# Reference: 
# https://github.com/glaucius/aws-terraform
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
# https://www.terraform.io/docs/providers/aws/d/internet_gateway.html

# Create Internet Nat Gateway
resource "aws_internet_gateway" "testing_nat_gw" {
  vpc_id = aws_vpc.vpc_testing.id

  tags = {
    Name = "nat, gateway, testing, vpc, terraform, aws"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc      = true

  tags = {
    Name = "nat, gateway, testing, vpc, terraform, aws"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.testing_subnet_public1.id
  depends_on    = [ aws_internet_gateway.testing_nat_gw ]

  tags = {
    Name = "nat, gateway, testing, vpc, terraform, aws"
  }
}