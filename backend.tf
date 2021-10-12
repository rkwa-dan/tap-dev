
terraform {
  backend "s3" {
    bucket = "tap-backend-state-s3"
    key    = "dev/state"
    region = "eu-west-2"
  }
}
