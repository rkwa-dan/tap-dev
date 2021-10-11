module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tap-dev-vpc"
  cidr = "10.98.0.0/16"

  azs             = ["eu-west-2a"]
  private_subnets = ["10.98.1.0/24"]
  public_subnets  = ["10.98.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output


//
//module "security-group" {
//  source  = "terraform-aws-modules/security-group/aws"
//  version = "4.3.0"
//  # insert the 3 required variables here
//
//  vpc = ${vpc.
//}
