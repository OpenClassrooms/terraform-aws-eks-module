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

provider "aws" {
  alias      = "root"
  region     = data.aws_ssm_parameter.aws_default_region_root.value
  access_key = data.aws_ssm_parameter.aws_access_key_id_root.value
  secret_key = data.aws_ssm_parameter.aws_secret_access_key_root.value
}
