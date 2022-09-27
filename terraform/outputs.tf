output "db_instance_class" {
  description = "The RDS instance class"
  value       = aws_db_instance.this.instance_class
}

output "db_instance_username" {
  description = "The database username"
  value       = aws_db_instance.this.username
}

output "db_instance_db_name" {
  description = "The database username"
  value       = aws_db_instance.this.db_name
}

output "db_instance_endpoint" {
  description = "The database endpoint"
  value       = aws_db_instance.this.endpoint
}
