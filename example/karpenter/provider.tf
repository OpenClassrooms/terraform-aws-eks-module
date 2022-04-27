terraform {
  required_version = ">=v1.0.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "aws" {
  alias      = "root"
  region     = data.aws_ssm_parameter.aws_default_region_root.value
  access_key = data.aws_ssm_parameter.aws_access_key_id_root.value
  secret_key = data.aws_ssm_parameter.aws_secret_access_key_root.value
}

provider "helm" {
  kubernetes {
    host                   = data.aws_ssm_parameter.endpoint.value
    cluster_ca_certificate = base64decode(data.aws_ssm_parameter.cluster_ca_certificate.value)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_ssm_parameter.cluster_name.value]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = data.aws_ssm_parameter.endpoint.value
  cluster_ca_certificate = base64decode(data.aws_ssm_parameter.cluster_ca_certificate.value)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_ssm_parameter.cluster_id.value]
  }
}
