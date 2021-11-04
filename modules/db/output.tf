output "db-info" {
    value = {
        db_name = aws_db_instance.default.name,
        db_port = aws_db_instance.default.port
    }
    description = "Database key information."
}