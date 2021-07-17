resource "aws_db_subnet_group" "acg-db-subnet" {
  name       = "acg-db-subnet"
  subnet_ids = [aws_subnet.dbsubnet1.id, aws_subnet.dbsubnet2.id]

  tags = {
    name = "postgres-subnets"
  }
}

resource "aws_db_instance" "acg-db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = var.db_class
  name                 = "postgres"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
  storage_encrypted    = false
  db_subnet_group_name = "acg-db-subnet"
}

