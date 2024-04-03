# Create a VPC
resource "aws_vpc" "onlinevpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = { 
    Name = "${var.project_name}-vpc"
  }
}


# Create A Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.onlinevpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#Use data source to get all availability zones in region
data "aws_availability_zones" "availability_zones" {}

#Create Public Subnet AZ1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.onlinevpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true    

  tags = {
    Name                       = "public-subnet-az1"
  }
}

#Create Public Subnet AZ2

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.onlinevpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true    

  tags = {
    Name                       = "public-subnet-az2"
  }
}

#Create a route table and add public route
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.onlinevpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }

  tags = {
    Name = "public-route"
  }
}


#Associate the public subnet az1 to public-route
resource "aws_route_table_association" "public-subnet-az1-rt-association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public-route.id
}

#Associate the public subnet az2 to public-route
resource "aws_route_table_association" "public-subnet-az2-rt-association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public-route.id
}


#Create a private app subnet az1
resource "aws_subnet" "private-app-subnet-az1" {
  vpc_id            = aws_vpc.onlinevpc.id
  cidr_block        = var.private_app_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name                            = "private app subnet az1"
  }
}

resource "aws_subnet" "private-app-subnet-az2" {
  vpc_id            = aws_vpc.onlinevpc.id
  cidr_block        = var.private_app_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[1]

  tags = {
    Name                            = "private app subnet az2"
  }
}


