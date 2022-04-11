provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

#vpc creation

resource "aws_vpc" "spoke1vpc" {
  cidr_block = "172.35.0.0/16"

  tags = {
    name = "spoke1-vpc"
  }
}

#Created internet gateway
resource "aws_internet_gateway" "igspoke1" {
  vpc_id = aws_vpc.spoke1vpc.id

  tags = {
    Name = "igspoke1"
  }
}

#creating routetable
resource "aws_route_table" "route-private-spoke1" {
  vpc_id = aws_vpc.spoke1vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igspoke1.id
  }

   route {
    ipv6_cidr_block        = "::/0"
    gateway_id             = aws_internet_gateway.igspoke1.id
  }
 
  tags = {
    Name = "route-table-spoke1"
  }
}

# Create a pvt-subnets main1,main2,main3

resource "aws_subnet" "pvt_main1" {
  vpc_id     = aws_vpc.spoke1vpc.id
  cidr_block = "172.35.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet1-spoke1"
  }
}

# Create a private-subnet2
resource "aws_subnet" "pvt_main2" {
  vpc_id     = aws_vpc.spoke1vpc.id
  cidr_block = "172.35.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet2-spoke1"
  }
}

# Create a private-subnet3
resource "aws_subnet" "pvt_main3" {
  vpc_id     = aws_vpc.spoke1vpc.id
  cidr_block = "172.35.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-subnet3-spoke1"
  }
}

#Associate subnet with route table
resource "aws_route_table_association" "route-private-spoke1-main1" {
  subnet_id      = aws_subnet.pvt_main1.id
  route_table_id = aws_route_table.route-private-spoke1.id
}
resource "aws_route_table_association" "route-private-spoke1-main2" {
  subnet_id      = aws_subnet.pvt_main2.id
  route_table_id = aws_route_table.route-private-spoke1.id
}
resource "aws_route_table_association" "route-private-spoke1-main3" {
  subnet_id      = aws_subnet.pvt_main3.id
  route_table_id = aws_route_table.route-private-spoke1.id
}
