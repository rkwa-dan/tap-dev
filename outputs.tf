#output "vpc_id" {
#  value       = module.vpc.vpc_id
#  description = "ID of project VPC"
#}
#
#output "subnet-priv" {
#  value = module.vpc.aws_subnet.private
#  description = "Private Subnet ID"
#}
#
#output "subnet-pub" {
#  value  = module.vpc.aws_subnet.public
#  description = "Public Subnet ID"
#
#}