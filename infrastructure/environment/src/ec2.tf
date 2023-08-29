
resource "aws_instance" "ec2_instance" {
  ami           = "ami-08a52ddb321b32a8c" # Change this to your desired Amazon Machine Image (AMI)
  instance_type = "t2.micro"              # Change this to your desired instance type
  security_groups = [aws_security_group.SecurityGroup1.id]
  subnet_id = aws_subnet.PublicSubnet1.id
  

  tags = {
    Name        = "Bastion_host"       # Example tag; you can replace this with your desired tag
    Environment = "new_developmentsdsd" # Another example tag
  }

   key_name      = "newkeeeey1" # Replace with the name of your existing EC2 key pair
}






