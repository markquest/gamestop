#Load Balancer
resource "aws_lb" "ecs_alb" {
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb-sec-grp.id]
 subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

 tags = {
   Name = "ecs-alb"
 }
}

resource "aws_lb_listener" "ecs_alb_listener" {
 load_balancer_arn = aws_lb.ecs_alb.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg.arn
 }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = var.app_port
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.vpc-1.id

 health_check {
   path = "/"
 }
}
