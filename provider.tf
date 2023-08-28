terraform {

  required_version = ">= 1.2.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.66.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}