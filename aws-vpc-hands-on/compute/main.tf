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



# Public EC2 Instances
resource "aws_key_pair" "my_testing_key" {
  key_name   = "my-testing-key"
  public_key = file("~/.ssh/my-testing-key.pub")
}

resource "aws_instance" "my_testing_ec2_public_1" {
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


# Private EC2 instance
resource "aws_instance" "my_testing_ec2_private_1" {
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

# Elastic IP # 18.199.54.175
resource "aws_eip" "my_testing_eip" {
  instance = aws_instance.my_testing_ec2_private_1.id
  vpc = true
}