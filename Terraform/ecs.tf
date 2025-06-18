resource "aws_ecs_cluster" "this" {
  name = "ror-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ror-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "ror"
      image = "<ECR_IMAGE_URL>"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ],
      environment = [
        {
          name  = "DATABASE_HOST"
          value = aws_db_instance.rds.address
        },
        {
          name  = "DATABASE_USER"
          value = var.db_username
        },
        {
          name  = "DATABASE_PASSWORD"
          value = var.db_password
        }
      ]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_execution.arn
}
