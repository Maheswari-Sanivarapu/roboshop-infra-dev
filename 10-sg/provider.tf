terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.98.0"
    }
  }
 backend "s3"{
    bucket = "mahi-s3-bucket-dev"
    #bucket = "mahi-s3-bucket-dev-1"
    key = "remote-state-dev-sg"
    region = "us-east-1"
    #region = "ap-south-1"
    encrypt = true 
    use_lockfile = true
  }
}

provider "aws" {
  # Configuration options
  # region
  region = "us-east-1"
  #region = "ap-south-1"
}