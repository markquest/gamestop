resource "aws_instance" "jenkins-ec2" {
  ami                    = "ami-0f403e3180720dd7e"
  subnet_id = aws_subnet.public-us-east-1a.id
  instance_type          = "t2.medium"
  key_name        = "firstkeymac"
  vpc_security_group_ids      = [aws_security_group.myjenkins_sg.id]
  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "sonarqube" {
  ami                    = "ami-0f403e3180720dd7e"
  subnet_id = aws_subnet.public-us-east-1a.id
  instance_type          = "t2.medium"
  key_name        = "firstkeymac"
  vpc_security_group_ids      = [aws_security_group.mysonar-sg.id]
  tags = {
    Name = "sonarqube"
  }
}

#Create Nexus Server
resource "aws_instance" "nexus-server" {
  ami                    = "ami-0f403e3180720dd7e"
  subnet_id = aws_subnet.public-us-east-1a.id
  instance_type          = "t2.medium"
  key_name        = "firstkeymac"
  vpc_security_group_ids      = [aws_security_group.mynexus-sg.id]
  tags = {
    Name = "nexus-server"
  }
}

#Create security group for Jenkins
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

resource "aws_security_group" "mysonar-sg" {
  name        = "sonar-sg20"
  description = "Allow inbound ports 22, 8080"
  vpc_id      = aws_vpc.onlinevpc.id

  ingress {
    from_port   = 9000  # SonarQube
    to_port     = 9000 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "mynexus-sg" {
  name        = "nexus-sg20"
  description = "Allow inbound ports 22, 8080"
  vpc_id      = aws_vpc.onlinevpc.id

  ingress {
    from_port   = 8081  # Nexus Server
    to_port     = 8081 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}