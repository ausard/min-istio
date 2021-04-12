resource "random_string" "kubernetes_dashboard_csrf" {
  length           = 16
  special          = true
  override_special = "/@£$"
}