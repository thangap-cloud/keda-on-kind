terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.0.12"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    helm        = {
      source    = "hashicorp/helm"
      version   = "~> 2.2.0"
    }

  }
}

provider "kind" {}