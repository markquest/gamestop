#ALB-sec-group
resource "aws_security_group" "alb-sec-grp" {
 name   = "alb-sec-grp"
 vpc_id = aws_vpc.vpc-1.id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


##ECS-SEC-GRP
resource "aws_security_group" "ecs-tasks" {
  name        = "ecs-tasks"#"myapp-ecs-tasks-security-group"
  # description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.vpc-1.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.alb-sec-grp.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}