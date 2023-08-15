
provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds_credentials"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = "{\"username\":\"admin\",\"password\":\"yourpasswordhere\"}"
}
