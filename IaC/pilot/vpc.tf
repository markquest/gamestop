# Create a VPC
resource "aws_vpc" "onlinevpc" {
  cidr_block = "10.0.0.0/16"

  tags = { 
    Name = "main"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.onlinevpc.id

  tags = {
    Name = "igw"
  }
}


provider "aws" {
  region = "us-east-1"
}





resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
