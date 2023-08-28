resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "external_dns" {

  name       = "external-dns"
  repository = var.chart_repo_url
  version    = var.chart_repo_version
  chart      = "external-dns"
  namespace  = var.namespace_name
  timeout    = 600
  values     = length(var.helm_values) > 0 ? var.helm_values : ["${file("${path.module}/helm-values.yaml")}"]

  set {
    name  = "txtOwnerId"
    value = var.txt_owner_id
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = google_service_account.service_account.email
    type  = "string"
  }

  set {
    name  = "domainFilters"
    value = "{${join(",", var.domain_filters)}}"
  }

  dynamic "set" {
    for_each = var.extra_set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = set.value.type
    }
  }

  depends_on = [
    kubernetes_namespace.external_dns,
    google_project_iam_member.iam_member
  ]
}
