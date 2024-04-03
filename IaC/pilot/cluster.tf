provider "aws" {
  region  = "us-east-1"
}


variable "sec-gr-mutual" {
  default = "gamestop-k8s-mutual-sec-group"
}

variable "sec-gr-k8s-master" {
  default = "gamestop-k8s-master-sec-group"
}

variable "sec-gr-k8s-worker" {
  default = "gamestop-k8s-worker-sec-group"
}

data "aws_vpc" "name" {
  default = true
}

resource "aws_security_group" "gamestop-mutual-sg" {
  name = var.sec-gr-mutual
  vpc_id = data.aws_vpc.name.id
  
   ingress {
    protocol = "tcp"
    from_port = 6443
    to_port = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }  

   ingress {
    protocol = "tcp"
    from_port = 25
    to_port = 25
    cidr_blocks = ["0.0.0.0/0"]
  }

 
   ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    protocol = "tcp"
    from_port = 465
    to_port = 465
    cidr_blocks = ["0.0.0.0/0"]
  }

    
   ingress {
    protocol = "tcp"
    from_port = 3000
    to_port = 10000
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
   
   ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }


   ingress {
    protocol = "tcp"
    from_port = 3000
    to_port = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "gamestop-master-server-s3-role" {
  name               = "gamestop-master-server-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}

resource "aws_iam_instance_profile" "gamestop-master-server-profile" {
  name = "gamestop-master-server-profile"
  role = aws_iam_role.gamestop-master-server-s3-role.name
}

resource "aws_instance" "kube-master" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.medium"
    iam_instance_profile = aws_iam_instance_profile.gamestop-master-server-profile.name
    vpc_security_group_ids = [aws_security_group.gamestop-mutual-sg.id]
    key_name = "firstkeymac"
    subnet_id = "subnet-036c9fcba7fd0148f"  # select own subnet_id of us-east-1a
    availability_zone = "us-east-1a"
    tags = {
        Name = "kube-master"
        Project = "tera-kube-ans"
        Role = "master"
        Id = "1"
        environment = "dev"
    }
}

resource "aws_instance" "worker-1" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.medium"
    vpc_security_group_ids = [aws_security_group.gamestop-mutual-sg.id]
    key_name = "firstkeymac"
    subnet_id = "subnet-036c9fcba7fd0148f"  # select own subnet_id of us-east-1a
    availability_zone = "us-east-1a"
    tags = {
        Name = "worker-1"
        Project = "tera-kube-ans"
        Role = "worker"
        Id = "1"
        environment = "dev"
    }
}

resource "aws_instance" "worker-2" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.medium"
    vpc_security_group_ids = [aws_security_group.gamestop-mutual-sg.id]
    key_name = "firstkeymac"
    subnet_id = "subnet-036c9fcba7fd0148f"  # select own subnet_id of us-east-1a
    availability_zone = "us-east-1a"
    tags = {
        Name = "worker-2"
        Project = "tera-kube-ans"
        Role = "worker"
        Id = "2"
        environment = "dev"
    }
}

output kube-master-ip {
  value       = aws_instance.kube-master.public_ip
  sensitive   = false
  description = "public ip of the kube-master"
}

output worker-1-ip {
  value       = aws_instance.worker-1.public_ip
  sensitive   = false
  description = "public ip of the worker-1"
}

output worker-2-ip {
  value       = aws_instance.worker-2.public_ip
  sensitive   = false
  description = "public ip of the worker-2"
}
