provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-123"
    key    = "new_state"
    region = "us-east-1"
    # dynamodb_table = "my-lock-table-kdfkjgjjffj"
  }
}

data "aws_availability_zones" "available" {
		  state = "available"
		}

resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}



resource "aws_subnet" "PublicSubnet1" {
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.VPC.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Public Subnet AZ_B_1"
  }
}



resource "aws_subnet" "PrivateSubnet1" {
  cidr_block = "10.0.10.0/24"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.VPC.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Private Subnet AZ_A"
  }
}



resource "aws_subnet" "PrivateSubnet2" {
  cidr_block = "10.0.11.0/24"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.VPC.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Private Subnet AZ_B"
  }
}

resource "aws_route_table" "RouteTablePublic" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [ aws_internet_gateway.Igw ]

  tags = {
    Name = "Public Route Table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }
}

resource "aws_route_table_association" "AssociationForRouteTablePublic0" {
  subnet_id = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.RouteTablePublic.id
}



resource "aws_route_table" "RouteTablePrivate1" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [ aws_nat_gateway.NatGw1 ]

  tags = {
    Name = "Private Route Table A"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGw1.id
  }
}

resource "aws_route_table_association" "AssociationForRouteTablePrivate10" {
  subnet_id = aws_subnet.PrivateSubnet1.id
  route_table_id = aws_route_table.RouteTablePrivate1.id
}



resource "aws_route_table" "RouteTablePrivate2" {
  vpc_id = aws_vpc.VPC.id
  depends_on = [ aws_nat_gateway.NatGw1 ]

  tags = {
    Name = "Private Route Table B"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGw1.id
  }
}

resource "aws_route_table_association" "AssociationForRouteTablePrivate20" {
  subnet_id = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.RouteTablePrivate2.id
}



resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "New_IGW"
  }
}

resource "aws_eip" "EipForNatGw1" {
}

resource "aws_nat_gateway" "NatGw1" {
  allocation_id = aws_eip.EipForNatGw1.id
  subnet_id = aws_subnet.PublicSubnet1.id

  tags = {
    Name = "NAT GW A"
  }
}

resource "aws_security_group" "SecurityGroup1" {
  name = "allow-ssh-traffic"
  description = "A security group that allows inbound SSH traffic (TCP port 22)."
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.250.89.170/32",]
    description = "Allow SSH traffic"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "SecurityGroup2" {
  name = "allow-web-traffic"
  description = "A security group that allows inbound web traffic (TCP ports 80 and 443)."
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["172.250.89.170/32"]
    description = "Allow HTTP traffic"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["172.250.89.170/32"]
    description = "Allow HTTPS traffic"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}