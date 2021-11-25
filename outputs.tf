output "vpc_id" {
  value       = aws_vpc.tap-vpc.id
  description = "VPC ID"
}

output "subnet-priv" {
  value = aws_subnet.dev.id
  description = "Private Subnet ID"
}

output "default-route-table-id" {
  value = aws_vpc.tap-vpc.default_route_table_id
  description = "Tap VPC default route table ID"
}

output "internet-gw" {
  value = aws_vpc.tap-vpc.main_route_table_id
  description = "Tap VPC main route table ID"
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
  //value = module.ec2_instance.id

value = tomap ({
  for k, inst in module.ec2_instance : k => inst.id
})
}

output "private-ip" {
#  value = module.ec2_instance.private_ip

  value = tomap ({
  for k, inst in module.ec2_instance : k => inst.private_ip
  })
}

output "public-ip" {
  #  value = module.ec2_instance.private_ip

  value = tomap ({
  for k, inst in module.ec2_instance : k => inst.public_ip
  })
}

#
#output "public_ip" {
#  value = module.ec2_instance.public_ip.value
#}
#
#output "public-fqdn" {
#  value = module.ec2_instance.public_dns.value
#}
