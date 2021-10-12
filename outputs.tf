
output "vpc_id" {
  description = "ID of project VPC"
  value       = module.vpc.vpc_id
}

output "subnet-private" {
  description "Private Subnet ID"
  value = module.vpc.aws_subnet.private
}

output "subnet-private" {
  description "Private Subnet ID"
  value = module.vpc.aws_subnet.public
}