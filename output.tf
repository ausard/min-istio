# output "kubernetes_dashboard_view_only_token" {
#   value = var.token
# }

output "mapping" {
  value = module.k8s-dashboard.mapping
}