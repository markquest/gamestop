resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

data "template_file" "myapp" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.region
  }
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "myapp-task"
  network_mode             = var.network_mode
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  cpu   = var.fargate_cpu
  memory = var.fargate_memory
  
  container_definitions = data.template_file.myapp.rendered
}

resource "aws_ecs_service" "my_service" {
  name            = "myapp-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    security_groups  = [aws_security_group.ecs-tasks.id]
    subnets = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id] 
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = var.load_balancer_container_name
    container_port   = var.app_port
  }

  depends_on = [aws_lb_target_group.ecs_tg]
}