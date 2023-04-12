terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 3.27"
      version = "~> 4.62"

    }
  }
}


provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

provider "tls" {
  # Configuration options
}