terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key              = var.TF_VAR_AWS_ACCESS_KEY_ID
  secret_key              = var.TF_VAR_AWS_SECRET_ACCESS_KEY
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "${var.project_name}-sg"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "nginx" {
  ami           = var.ubuntu_ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.auth.id
  subnet_id     = aws_subnet.main.id

  vpc_security_group_ids = [aws_security_group.allow_web.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "${var.project_name}-nginx"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)
}

resource "aws_eip" "nginx_eip" {
  instance = aws_instance.nginx.id

  tags = {
    Name = "${var.project_name}-eip"
  }
}
