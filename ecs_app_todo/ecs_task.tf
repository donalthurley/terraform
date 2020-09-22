# Task
data "template_file" "todo_app" {
  template = file("${path.module}/templates/ecs_task.tpl")

  vars = {
    app_image_repository = var.app_image_repository
    app_image_version = var.app_image_version
    app_name = var.app_name
    container_port = var.container_port
    pghost = data.terraform_remote_state.rds.outputs.pghost
    pgdatabase = data.terraform_remote_state.rds.outputs.pgdatabase
    pguser = data.terraform_remote_state.rds.outputs.pguser
    pgpassword = data.terraform_remote_state.rds.outputs.pgpassword
    pgsslmode = var.pgsslmode
    region = var.region    
  }
}

resource "aws_ecs_task_definition" "todo_app" {
  family = var.app_name
  container_definitions = data.template_file.todo_app.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "todo_app" {
  name            = "${var.app_name}-service-${var.environment}"
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.cluster_arn
  task_definition = aws_ecs_task_definition.todo_app.arn
  desired_count   = 3
  launch_type     = "FARGATE"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  load_balancer {
    container_name   = var.app_name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.todo_app.arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.todo_app.id]
    subnets = tolist(data.terraform_remote_state.vpc.outputs.public_subnets)
  }

  depends_on = [
    aws_alb_listener.todo_app,
  ]

}

# Security Group
resource "aws_security_group" "todo_app" {
  name_prefix = "Todo App SG"
  description = "Allow all inbound/outbound traffic"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_inbound_todo_app" {
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  security_group_id = aws_security_group.todo_app.id
  source_security_group_id = aws_security_group.lb.id  
}

resource "aws_security_group_rule" "allow_all_outbound_todo_app" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.todo_app.id
}
