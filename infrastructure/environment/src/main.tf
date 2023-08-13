
provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-08a52ddb321b32a8c" # Change this to your desired Amazon Machine Image (AMI)
  instance_type = "t2.micro"             # Change this to your desired instance type

  tags = {
    Name = "MyEC2Instance"              # Example tag; you can replace this with your desired tag
    Environment = "new_development"          # Another example tag
  }

  # key_name      = "your_key_pair_name" # Replace with the name of your existing EC2 key pair
}


terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-123"
    key            = "new_state"
    region         = "us-west-1"
    # dynamodb_table = "my-lock-table"
  }
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}




