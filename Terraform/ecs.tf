
resource "aws_ecs_cluster" "this" {
  name = "ror-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ror-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([
    {
      name  = "ror",
      image = "489502444480.dkr.ecr.ap-south-1.amazonaws.com/devops-ror-app:v1.0.0",
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000
        }
      ],
      environment = [
        {
          name  = "RAILS_ENV",
          value = "production"
        },
        {
          name  = "RDS_DB_NAME",
          value = "rorappdb"
        },
        {
          name  = "RDS_USERNAME",
          value = var.db_username
        },
        {
          name  = "RDS_PASSWORD",
          value = var.db_password
        },
        {
          name  = "RDS_HOSTNAME",
          value = aws_db_instance.rds.address
        },
        {
          name  = "RDS_PORT",
          value = "5432"
        },
        {
          name  = "ACCESS_KEY_ID",
          value = ""
        },
        {
          name  = "SECRET_ACCESS_KEY",
          value = ""
        },
        {
          name  = "BUCKET",
          value = aws_s3_bucket.app_bucket.bucket
        },
        {
          name  = "REGION",
          value = var.aws_region
        }
      ]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_execution.arn
}

resource "aws_ecs_service" "app_service" {
  name            = "ror-app-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "ror"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener]
}
