
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#creating up a remote state backend in s3
terraform {
  backend "s3" {
    bucket = "projects34758463648"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}