locals {
  project         = data.terraform_remote_state.vpc.outputs.project
  region          = data.terraform_remote_state.vpc.outputs.region
  zones           = data.terraform_remote_state.vpc.outputs.zones
  cluster_id      = data.terraform_remote_state.gke.outputs.cluster_id
  endpoint        = data.terraform_remote_state.gke.outputs.endpoint
  cluster_name    = data.terraform_remote_state.gke.outputs.name
  namespace       = "external-dns"
  service_account = "external-dns"
  domain  = "demo.gcp.canux.com"
  sa_sufix        = "external-dns"
}

####################
# Data
####################
data "google_container_cluster" "this" {
  name     = local.cluster_name
  location = local.region
}

data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = "myproject-tst-iac"
    prefix = "terraform/eu-west-4/vpc.tfstate"
  }
}

data "terraform_remote_state" "gke" {
  backend = "gcs"
  config = {
    bucket = "myproject-tst-iac"
    prefix = "terraform/eu-west-4/gke.tfstate"
  }
}

data "google_client_config" "client" {}

####################
# provider
####################
provider "google" {
  project = local.project
  region  = local.region
}

provider "helm" {
  kubernetes {
    token                  = data.google_client_config.client.access_token
    host                   = data.google_container_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  token                  = data.google_client_config.client.access_token
  host                   = "https://${data.google_container_cluster.this.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
}

module "external_dns" {
  source          = "../../terraform-gcp-external-dns"
  sa_sufix   = local.sa_sufix
  project_id = local.project
  extra_set_values = [{
    name  = "nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
    type  = "string"
  }]

  txt_owner_id   = local.cluster_name
  chart_repo_url       = "https://kubernetes-sigs.github.io/external-dns/"
  chart_repo_version   = "1.13.0"
  namespace_name       = local.namespace
  service_account_name = local.service_account
  domain_filters = [local.domain]
}