resource "aws_vpc" "vpc-1" {
 cidr_block           = var.vpc_cidr
 enable_dns_hostnames = true
 tags = {
   name = "vpc-1"
 }
}


resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc-1.id
    cidr_block = "10.0.1.0/24"
    availability_zone = var.availability_zone
    map_public_ip_on_launch = var.map_public_ip_on_launch
}
resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.vpc-1.id
    cidr_block = "10.0.4.0/24"
    availability_zone = var.availability_zone
    map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.vpc-1.id
    cidr_block = "10.0.2.0/24"
    availability_zone = var.availability_zone2
    map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_internet_gateway" "internet-gateway-1" {
    vpc_id = aws_vpc.vpc-1.id
    tags = {
        Name = "internet-gateway-1"
    }   
}
resource "aws_route_table" "route-table-private" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table" "route-table-public" {
    vpc_id = aws_vpc.vpc-1.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet-gateway-1.id

    }   
}

resource "aws_route_table_association" "subnet1-route" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route-table-public.id

}

resource "aws_route_table_association" "subnet2-route" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route-table-public.id

}

resource "aws_route_table_association" "private-route" {
  subnet_id      = aws_subnet.private-subnet-1.id      
  route_table_id = aws_route_table.route-table-private.id  
}
