provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "test_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "practice"
  }
}
# Subnet
resource "aws_subnet" "test_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "practice"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "test_gateway" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "practice"
  }
}

# Route Table
resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }

  tags = {
    Name = "practice"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "test" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_route_table.id
}

# Security Group
resource "aws_security_group" "test_security_group" {
  name        = "terraform-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "practice"
  }
}

# EC2 Instance
resource "aws_instance" "test_instance" {
  ami                    = "ami-0c02fb55956c7d316"  # Amazon Linux 2 for us-east-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.test_subnet.id
  vpc_security_group_ids = [aws_security_group.test_security_group.id]

  tags = {
    Name = "practice"
  }
}