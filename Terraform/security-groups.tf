resource "aws_security_group" "public-sg" {
  vpc_id      = aws_vpc.main.id
  description = "EC2 Security Group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  
  tags = {
    Name = "ec2-SG"
  }
}

resource "aws_security_group" "db-sg" {
  vpc_id      = aws_vpc.main.id
  description = "Database Security Group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }


  tags = {
    Name = "db-sg"
  }
}

resource "aws_security_group" "redis-sg" {
  vpc_id      = aws_vpc.main.id
  description = "Redis Security Group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  tags = {
    Name = "redis-sg"
  }
}

