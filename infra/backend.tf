# PROVIDER
provider "aws" {
  region = "eu-west-1"
}

# BACKEND
terraform {
  backend "s3" {
    bucket = "image-rekognition-states-demo"
    key    = "infra/terraform.tfstates"
    region = "eu-west-1"
  }
}