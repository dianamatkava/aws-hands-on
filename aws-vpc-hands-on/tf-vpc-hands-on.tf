provider "aws" {
  region = "eu-central-1"
}

# VPC
resource "aws_vpc" "my_testing_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Internet Gateway
resource "aws_internet_gateway" "my_testing_igw" {
  vpc_id = aws_vpc.my_testing_vpc.id
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
resource "aws_eip" "my_testing_eip" {
  vpc = true
}

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

# Security Groups
resource "aws_security_group" "launch_wizard_1" {
  name_prefix = "launch-wizard-1"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "my_testing_sg" {
  name_prefix = "my-testing-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances
resource "aws_key_pair" "my_testing_key" {
  key_name   = "my-testing-key"
  public_key = file("~/.ssh/my-testing-key.pub") # Make sure to use your actual key here
}

resource "aws_instance" "my_testing_ec2_public_1" {
  ami           = "ami-xxxxxxxxxx" # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_testing_public_subnet_1b.id
  key_name      = aws_key_pair.my_testing_key.key_name
  security_groups = [aws_security_group.launch_wizard_1.name]

  associate_public_ip_address = true

  private_ip = "172.31.38.139"
  tags = {
    Name = "my-testing-ec2-public-1"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/my-testing-key-ec2.pem")
    host        = self.public_ip
  }
}

resource "aws_instance" "my_testing_ec2_private_1" {
  ami           = "ami-xxxxxxxxxx" # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_testing_private_subnet_1a.id
  key_name      = aws_key_pair.my_testing_key.key_name
  security_groups = [aws_security_group.my_testing_sg.name]

  private_ip = "10.0.0.12"
  tags = {
    Name = "my-testing-ec2-private-1"
  }

  connection {
    type = "ssh"
    host = self.private_ip
    user = "ec2-user"
  }
}

# Outputs
output "my_testing_ec2_public_ip" {
  value = aws_instance.my_testing_ec2_public_1.public_ip
}

output "my_testing_ec2_private_ip" {
  value = aws_instance.my_testing_ec2_private_1.private_ip
}
