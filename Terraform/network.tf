# primary VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc_main"
  }
}

#allow access to list of AWS availability zones 
data "aws_availability_zones" "available" {}

#public, ec2
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = element(data.aws_availability_zones.available.names, 0)
  tags = {
    Name = "public"
  }
}

#private, redis 
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = element(data.aws_availability_zones.available.names, 1)
  tags = {
    Name = "private"
  }
}

#db subnet - rds
resource "aws_subnet" "dbsubnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = element(data.aws_availability_zones.available.names, 2)
  tags = {
    Name = "dbsubnet1"
  }
}

#failover - rds 
resource "aws_subnet" "dbsubnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = element(data.aws_availability_zones.available.names, 3)
  tags = {
    Name = "dbsubnet2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pub-rt"
  }
}

resource "aws_route_table_association" "pubsubnet-rt" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "priv-rt"
  }
}

resource "aws_route_table_association" "privsubnet-rt" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.priv-rt.id
}

resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "db-rt"
  }
}

resource "aws_route_table_association" "dbsubnetrt1" {
  subnet_id      = aws_subnet.dbsubnet1.id
  route_table_id = aws_route_table.db-rt.id
}

resource "aws_route_table_association" "dbsubnetrt2" {
  subnet_id      = aws_subnet.dbsubnet2.id
  route_table_id = aws_route_table.db-rt.id
}

resource "aws_eip" "ip" {
  tags = {
    Name = "nat-EIP"
  }
}

resource "aws_nat_gateway" "ngw" {
  depends_on = [aws_internet_gateway.igw]

  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.public.id
}