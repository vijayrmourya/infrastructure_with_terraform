terraform {
  required_version = ">= 1.0.11" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "> 2.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "> 3.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "> 3.62.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "> 2.2.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "> 2.0.0"
    }
  }
}

provider "aws" {
  profile = var.aws_user_profile
  region  = var.aws_default_region
  #  https://registry.terraform.io/providers/hashicorp/aws/latest/docs
}