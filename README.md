# external-dns for gcp

## Example Usage

```
module "external_dns" {
  source = "../../terraform-gcp-external-dns"
  sa_sufix        = local.sa_sufix
  project_id      = local.project
  txt_owner_id         = local.cluster_name
  namespace_name       = local.namespace
  service_account_name = local.service_account
  domain_filters = [local.domain1, local.domain2]
  extra_set_values = local.extra_set_values
}
```
