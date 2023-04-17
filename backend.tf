
terraform {
  backend "s3" {
    bucket = "gse-ps-backend-state-s3"
    key    = "dev/sandbox-linux/state"
    region = "us-west-2"
  }
}
