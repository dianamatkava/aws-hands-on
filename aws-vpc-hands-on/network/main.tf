# VPC
resource "aws_vpc" "my_testing_vpc" {
  cidr_block = "10.0.0.0/16"
}

# ACL
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.my_testing_vpc.id
}

# Internet Gateway
resource "aws_internet_gateway" "my_testing_igw" {
  vpc_id = aws_vpc.my_testing_vpc.id
  tags = {
    Name = "my_testing_igw"
  }
}

# Subnets
resource "aws_subnet" "my_testing_private_subnet_1a" {
  vpc_id                  = aws_vpc.my_testing_vpc.id
  cidr_block              = "10.0.0.0/28"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "my_testing_public_subnet_1b" {
  vpc_id                  = aws_vpc.my_testing_vpc.id
  cidr_block              = "10.0.0.16/28"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
}

# Route Table for Public Subnet
resource "aws_route_table" "my_testing_rtb" {
  vpc_id = aws_vpc.my_testing_vpc.id
}

resource "aws_route_table_association" "my_testing_rtb_assoc" {
  subnet_id      = aws_subnet.my_testing_public_subnet_1b.id
  route_table_id = aws_route_table.my_testing_rtb.id
}



# NAT Gateway
resource "aws_nat_gateway" "my_testing_nat_gateway" {
  allocation_id = aws_eip.my_testing_eip.id
  subnet_id     = aws_subnet.my_testing_public_subnet_1b.id
}

# Route Table for Private Subnet
resource "aws_route_table" "my_testing_private_rtb" {
  vpc_id = aws_vpc.my_testing_vpc.id
}

resource "aws_route_table_association" "my_testing_private_rtb_assoc" {
  subnet_id      = aws_subnet.my_testing_private_subnet_1a.id
  route_table_id = aws_route_table.my_testing_private_rtb.id
}

resource "aws_route" "my_testing_private_route" {
  route_table_id         = aws_route_table.my_testing_private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_testing_nat_gateway.id
}