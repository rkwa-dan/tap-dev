output "vpc_id" {
  value       = aws_vpc.tap-vpc.id
  description = "VPC ID"
}

output "subnet-priv" {
  value = aws_subnet.dev.id
  description = "Private Subnet ID"
}

#output "subnet-pub" {
#  value  = module.vpc.aws_subnet.public
#  description = "Public Subnet ID"
#
#}

output "dev-vpc-sg" {
  value = aws_security_group.allow_ssh_anywhere.id
}

output "instance-id" {
  value = module.ec2_instance.id
}

output "private-ip" {
  value = module.ec2_instance.private_ip
}

#
#output "public_ip" {
#  value = module.ec2_instance.public_ip.value
#}
#
#output "public-fqdn" {
#  value = module.ec2_instance.public_dns.value
#}
