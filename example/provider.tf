terraform {
  required_version = ">=v1.0.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2"
    }
  }
}

provider "aws" {
}
