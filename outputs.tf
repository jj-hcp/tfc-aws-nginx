output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC created"
}

output "subnet_id" {
  value       = aws_subnet.main.id
  description = "The ID of the subnet created"
}

output "security_group_id" {
  value       = aws_security_group.allow_web.id
  description = "The ID of the security group created"
}

output "instance_id" {
  value       = aws_instance.nginx.id
  description = "The ID of the EC2 instance created"
}

output "instance_public_ip" {
  value       = aws_eip.nginx_eip.public_ip
  description = "The public IP address assigned to the EC2 instance"
}

output "instance_availability_zone" {
  value       = aws_subnet.main.availability_zone
  description = "The availability zone of the EC2 instance"
}

output "aws_eip" {
  value = aws.eip.nginx_eip.public_ip
}

# output "key_pair_name" {
#   value       = aws_key_pair.auth.key_name
#   description = "The name of the key pair used for the EC2 instance"
# }
