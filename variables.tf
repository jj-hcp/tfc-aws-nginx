variable "TF_VAR_AWS_ACCESS_KEY_ID" {
  description = "The AWS access key"
}

variable "TF_VAR_AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret key"
}

variable "cloudflare_api_token" {
  description = "The CloudFlare api token"
}

variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in"
  default     = "us-east-1"
}

variable "project_name" {
  description = "The project name to use for naming resources"
  default     = "nginx-project"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "The EC2 instance type for the Nginx server"
  default     = "t2.nano"
  #default     = "t2.nano"
}

variable "ubuntu_ami_id" {
  description = "The AMI ID for the Ubuntu 20.04 LTS image"
  default     = "ami-0b3b93a68ea39bbb5" #ChristmasCheckerApp
}

variable "public_key_path" {
  description = "The path to the public key for the EC2 instance"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_cidr_block" {
  description = "The CIDR block to allow SSH access from"
  default     = "0.0.0.0/0"
}
