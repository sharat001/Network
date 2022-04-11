provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}


#1. create vpc
resource "aws_vpc" "hub_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    "name" = "hub-vpc"
  }
}

#2. create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.hub_vpc.id

  tags = {
    Name = "main"
  }
}

#3. create a custom route table

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.hub_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id             = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "hub_rt_public"
  }

}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.hub_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id             = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "hub_rt_private"
  }

}


#4. create a subnet
# created private subnets a,b,c
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.hub_vpc.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "hub-sn-pvta"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.hub_vpc.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "hub-sn-pvtb"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id     = aws_vpc.hub_vpc.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "hub-sn-pvtc"
  }
}

#creating public subnets a,b,c
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.hub_vpc.id
  cidr_block = "172.16.4.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "hub-sn-puba"
  }
}
resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.hub_vpc.id
  cidr_block = "172.16.5.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "hub-sn-pubb"
  }
}
resource "aws_subnet" "public_subnet_c" {
  vpc_id     = aws_vpc.hub_vpc.id
  cidr_block = "172.16.6.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "hub-sn-pubc"
  }
}

#5. associate subnet with route table

resource "aws_route_table_association" "rt_public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_public_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "rt_private_c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.rt_private.id
}

#6. create security group to allow port 22,80,443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.hub_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
   }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

