resource "aws_db_instance" "default" {
  allocated_storage    = 10
  max_allocated_storage = 50
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "multi-tier-db"
  username             = var.db_user
  password             = var.db_pass
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  db_subnet_group_name = aws_db_subnet_group.sub_group.name
  multi_az             = true

  tags = {
    Name = "${var.resource_prefix}db"
  }
}

resource "aws_db_subnet_group" "sub_group" {
  name       = "main"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.resource_prefix}-sub-group"
  }
}