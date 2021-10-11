terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

//resource "aws_instance" "app_server" {
//  ami           = "ami-830c94e3"
//  instance_type = "t2.micro"
//
//  tags = {
//    Name = "ExampleAppServerInstance"
//  }
//}

terraform {
  backend "s3" {
    bucket = "tap-backend-state-s3"
    key    = "dev/state"
    region = "eu-west-2"
  }
}


data aws_vpc "tap-dev-vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "tap-dev-subnets" {
  vpc_id = "${var.tap-dev-vpc.vpc_id}"
}

data "aws_subnet" "tap-dev-subnet" {
  count = "${length(data.aws_subnet_ids.tap-dev-subnets.ids)}"
  id    = "${tolist(data.aws_subnet_ids.tap-dev-subnets.ids)[count.index]}"
}


resource "aws_key_pair" "dan-ssh-key" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9ov6dikJpIFEwKgUoEW8X5NM17Ik/Ow/Jg/K1Qon0DoV1lLK32S27ievK9oS59AmHl/gxDs7KKpCPfZyw+XDVxBYcxLMJMFLJmZgLro2I1jKFKUlm2nHCiHrFiPiM6+FCst/zecSl8Rkb0yyJq4OUlTF8clSn/NLUVQCxa1bQziRLoM3zxoNTwDSiHvTxcbktkrAlZvU+l5EvDe2cpa11GzgjsFGJmlgpqy5En/eUjeCN4sUDLMyvy2zgCxzZV39dOguKCiNcDSYgiSwi08888p3ZAd5ZtwTn4nf6s2fJiaisI9NTSRXn3Yk3Atk5IytW8TDndsciS6TWs8AMVyZ/ daniel@Daniels-MBP-2.lan"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

//aws-marketplace/Docker CE with CentOS 8.2-59fc5ef9-e1fc-44f8-a210-76e82995f2a5
  ami                    = "ami-0c7ebb2960dcde74f"
  instance_type          = "t2.micro"
  key_name               = "dan-ssh-key"
  monitoring             = true
  vpc_security_group_ids = ["sg-dev-access"]
  subnet_id              = "${data.aws_subnet.tap-dev-subnet.id}"


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}