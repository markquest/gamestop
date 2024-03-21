resource "aws_instance" "jenkins-ec2" {
  ami                    = "ami-0f403e3180720dd7e"
  instance_type          = "t2.micro"
  key_name        = ""
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "sonarqube" {
  ami                    = "ami-0f403e3180720dd7e"
  instance_type          = "t2.micro"
  key_name        = "firstkeymac"
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  tags = {
    Name = "sonarqube"
  }
}

#Create security group 
resource "aws_security_group" "myjenkins_sg" {
  name        = "jenkins_sg20"
  description = "Allow inbound ports 22, 8080"
  vpc_id      = aws_vpc.onlinevpc.id

  #Allow incoming TCP requests on port 22 from any IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#Allow incoming TCP requests on port 443 from any IP
  ingress {
    description = "Allow HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow incoming TCP requests on port 8080 from any IP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9000  # SonarQube
    to_port     = 9000 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}