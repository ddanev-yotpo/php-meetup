resource "aws_db_subnet_group" "this" {
  name       = "main"
  subnet_ids = [aws_subnet.this_a.id, aws_subnet.this_b.id]

  tags = {
    Name = "RDS subnet group"
  }
}
resource "aws_db_instance" "this" {
  allocated_storage      = 10
  identifier             = local.db_instance_name
  db_name                = local.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro"
  username               = local.db_user
  password               = local.db_pass
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.this.id
  vpc_security_group_ids = [aws_security_group.allow_rds.id]
  publicly_accessible    = true
}
