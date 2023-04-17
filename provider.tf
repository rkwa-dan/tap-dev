terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62.0"

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