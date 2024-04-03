output "region" {
  value = var.region
}

output "project_name" {
    value = var.project_name
}

output "vpc_id" {
    value = aws_vpc.onlinevpc.id  
}

output "public_subnet_az1_id" {
    value = aws_subnet.public_subnet_az1.id 
}

output "public_subnet_az2_id" {
    value = aws_subnet.public_subnet_az2.id
}

output "private_app_subnet_az1_id" {
    value = aws_subnet.private-app-subnet-az1
}

output "private_app_subnet_az2_id" {
    value = aws_subnet.private-app-subnet-az2.id
}

output "igw" {
    value = aws_internet_gateway.igw

}