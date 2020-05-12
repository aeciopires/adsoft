# Reference:
# https://github.com/glaucius/aws-terraform
# https://www.terraform.io/docs/providers/aws/d/route_table.html
# https://www.terraform.io/docs/providers/aws/d/route.html
# https://github.com/iaasweek/terraform

# Create route custom for public subnet
resource "aws_route_table" "route_table_testing_subnet_public1" {
  vpc_id = aws_vpc.vpc_testing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testing_nat_gw.id
  }

  tags = {
    Name = "route, public, nat, gateway, testing, vpc, terraform, aws"
  }
}

# Create route Access
#resource "aws_route" "internet_access" {
#  route_table_id         = aws_vpc.vpc_testing.route_table_testing_subnet_public1
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id             = aws_internet_gateway.testing_nat_gw.id
#}

# Associate route for public subnet
resource "aws_route_table_association" "route_testing_subnet_public1" {
  subnet_id      = aws_subnet.testing_subnet_public1.id
  route_table_id = aws_route_table.route_table_testing_subnet_public1.id
}


# Create route custom for private subnet
resource "aws_route_table" "route_table_testing_subnet_private1" {
  vpc_id = aws_vpc.vpc_testing.id

  route {
    cidr_block     = "0.0.0.0/0" //associated subnet can reach everywhere
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "route, private, nat, gateway, testing, vpc, terraform, aws"
  }
}

# Associate route for private subnet
resource "aws_route_table_association" "route_testing_subnet_private1" {
  subnet_id      = aws_subnet.testing_subnet_private1.id
  route_table_id = aws_route_table.route_table_testing_subnet_private1.id
}


