terraform {
  cloud {
    organization = "sonufrienko"
    workspaces {
      name = "dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23"
    }

    http = {
      source  = "hashicorp/http"
      version = "2.2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
  # profile = "cli"
}

provider "http" {}

provider "random" {}

provider "local" {}

provider "tls" {}
