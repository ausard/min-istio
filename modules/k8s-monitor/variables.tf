variable "aws_auth_config_map_id" { # Dependency on aws_auth configmap
  type = string
}
variable "kubernetes_dashboard_view_only_token" {
  type = string
}
variable "kubernetes_dashboard_service_namespace" {
  type = string
}
variable "kubernetes_dashboard_service_name" {
  type = string
}