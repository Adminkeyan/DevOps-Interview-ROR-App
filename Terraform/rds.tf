
resource "aws_db_instance" "rds" {
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  identifier             = "rorappdb"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds-subnet"
  subnet_ids = module.vpc.private_subnets
}
