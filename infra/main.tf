locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-vpc"
  })
}

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.1.0/24"
  availability_zone = "${var.region}a"

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-app-subnet"
  })
}

resource "aws_security_group" "app" {
  name        = "${var.project}-${var.environment}-app"
  description = "Minimal app security group for cost-aware deployment demos"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-app-sg"
  })
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.app.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-app"
  })
}
