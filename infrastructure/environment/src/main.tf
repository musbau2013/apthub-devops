
provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-08a52ddb321b32a8c" # Change this to your desired Amazon Machine Image (AMI)
  instance_type = "t2.micro"             # Change this to your desired instance type

  tags = {
    Name = "MyEC2Instance"              # Example tag; you can replace this with your desired tag
    Environment = "development"          # Another example tag
  }

  # key_name      = "your_key_pair_name" # Replace with the name of your existing EC2 key pair
}


output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}




