
resource "aws_vpc" "tap-vpc" {
#  name = "tap-dev-vpc"
  cidr_block = "10.98.0.0/16"
}

resource "aws_subnet" "dev" {
  vpc_id = aws_vpc.tap-vpc.id
  cidr_block = "10.98.1.0/24"

  tags = {
    Name = "Dev Subnet"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tap-vpc.id

  tags = {
    Name = "Tap Dev"
  }
}

resource "aws_route" "dev-default-route" {
  route_table_id = aws_vpc.tap-vpc.default_route_table_id
  destination_cidr_block  = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.gw.id

}
resource "aws_security_group" "allow_ssh_anywhere" {
  name        = "Allow SSH"
  description = "Allow SSH inbound traffic"
  #  source  = "terraform-aws-modules/security-group/aws"
  #  version = "4.3.0"
  # insert the 3 required variables here
 vpc_id = aws_vpc.tap-vpc.id

  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["46.69.40.20/32"]
  }

  ingress {
    description = "SSH - Perimeter81- 1"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["46.101.51.136/32"]
  }

  ingress {
    description = "SSH - Perimeter81 UK-2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["46.101.51.208/32"]
  }

  ingress {
    description = "ICMP from home"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["46.69.40.10/32"]
  }

  ingress {
    description = "ICMP from home"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["46.101.51.136/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow external access"
  }
}
