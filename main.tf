terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key              = var.TF_VAR_AWS_ACCESS_KEY_ID
  secret_key              = var.TF_VAR_AWS_SECRET_ACCESS_KEY
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-route-table"
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

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
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
  subnet_id     = aws_subnet.main.id

  vpc_security_group_ids = [aws_security_group.allow_web.id]

  tags = {
    Name = "${var.project_name}-nginx"
  }
}

resource "aws_eip" "nginx_eip" {
  instance = aws_instance.nginx.id

  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_eip_association" "nginx_eip_association" {
  instance_id   = aws_instance.nginx.id
  allocation_id = aws_eip.nginx_eip.id
}

resource "cloudflare_record" "christmas_app_dns_record" {
  zone_id = "584385595625440eab46794a4e5c3326"
  name    = "christmas.flctx.com"
  value   = aws_eip.nginx_eip.public_ip
  type    = "A"
  ttl     = 60
}