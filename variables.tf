# Folder for helm values files

variable "sa_sufix" {
  type    = string
  default = "external-dns"
}
variable "project_id" {
  type = string
}

variable "chart_repo_url" {
  description = "URL to repository containing the external-dns helm chart"
  type        = string
  default     = "https://kubernetes-sigs.github.io/external-dns/"
}

variable "chart_repo_version" {
  description = "URL to repository containing the external-dns helm chart"
  type        = string
  default     = "1.13.0"
}

variable "namespace_name" {
  description = "Name for external-dns namespace to be created by the module"
  type        = string
  default     = "external-dns"
}

variable "txt_owner_id" {
  description = "TXT registry identifier."
  type        = string
  default     = ""
}

variable "domain_filters" {
  description = "List of domain filters to limit possible target zones by domain suffixes."
  type        = list(string)
}

variable "service_account_name" {
  description = "Service account name"
  type        = string
}

variable "helm_values" {
  description = "Values for external-dns Helm chart in raw YAML."
  type        = list(string)
  default     = []
}

variable "extra_set_values" {
  description = "Specific values to override in the external-dns Helm chart (overrides corresponding values in the helm-value.yaml file within the module)"
  type = list(object({
    name  = string
    value = any
    type  = string
    })
  )
  default = []
}

