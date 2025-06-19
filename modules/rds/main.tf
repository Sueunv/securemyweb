

resource "aws_db_subnet_group" "this" {
  name       = "securemyweb-dbsubnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "postgres" {
  identifier          = "securemyweb-db"
  engine              = "postgres"
  engine_version      = "15.13"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = var.db_username
  password            = var.db_password
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.app_sg_id]
  skip_final_snapshot = true

  tags = {
    Name = "securemyweb-db"
  }
}

