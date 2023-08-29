

# data "aws_secretsmanager_secret" "rds_credentials" {
#   name = "rds_credentials"
# }

# data "aws_secretsmanager_secret_version" "rds_credentials" {
#   secret_id = data.aws_secretsmanager_secret.rds_credentials.id
# }

# resource "aws_db_subnet_group" "mysql_subnet_group" {
#   name       = "mysql-subnet-group"
#   subnet_ids = ["subnet-0257977fed2ce5720", "subnet-0ffa3afbfd3c7855e"] # Use private subnets from your VPC

#   tags = {
#     Name = "mysql-subnet-group"
#   }
# }


# resource "aws_db_parameter_group" "mysql_parameter_group" {
#   name   = "mysql-parameter-group"
#   family = "mysql5.7"

#   parameter {
#     name  = "max_connections"
#     value = "1000"
#   }

#   tags = {
#     Name = "mysql-parameter-group"
#   }
# }

# resource "aws_db_instance" "mysql" {
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t3.medium"
#   db_name                 = "mydb"
#   username             = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["username"]
#   password             = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)["password"]
#   parameter_group_name = aws_db_parameter_group.mysql_parameter_group.name
#   skip_final_snapshot  = true
#   db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
#   multi_az             = true # Enable Multi-AZ for high availability

#   # Backup
#   backup_retention_period = 7
#   backup_window           = "07:00-09:00"

#   # Maintenance
#   maintenance_window = "Sat:10:00-Sat:12:00"

#   tags = {
#     Name = "MyDB"
#   }
# }

# Optional: To use with applications in a VPC
# resource "aws_security_group" "mysql_sg" {
#   name        = "mysql-sg"
#   description = "MySQL Security Group"
# #   vpc_id      = "vpc-12345678"

  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"] # Only allow traffic from within the VPC or specific IPs
  # }

#   tags = {
#     Name = "mysql-sg"
#   }
# }
