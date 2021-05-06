variable "kubernetes_dashboard_namespace" {
  type = string
  default = "kubernetes-dashboard"
  description = "Kubernetes namespace to deploy kubernetes dashboard controller."
}

variable "kubernetes_dashboard_resources_labels" {
  type = map(string)
  default = {
      "application" = "kubernetes-dashboard"
      "owner" = "gds"
      "team" = "enable"
      "scope" = "platform"
      "context" = "v1"
      "istio-injection" = "disabled"
  }
  description = "Additional labels for kubernetes resources."
}

variable "kubernetes_dashboard_deployment_image_registry" {
  type = string
  default = "kubernetesui/dashboard"
}

variable "kubernetes_dashboard_image_tag" {
  type = string
  default = "v2.2.0"
}

variable "kubernetes_dashboard_deployment_metrics_scraper_image_registry" {
  type = string
  default = "kubernetesui/metrics-scraper"
}

variable "kubernetes_dashboard_deployment_metrics_scraper_image_tag" {
  type = string
  default = "v1.0.6"
}

variable "kubernetes_dashboard_deployment_node_selector" {
  type = map(string)
  default = {
    "kubernetes.io/os" = "linux"
  }
  description = "Node selectors for kubernetes deployment"
}

variable "kubernetes_dashboard_service_account_name" {
  type = string
  default = "kubernetes-dashboard"
  description = "Kubernetes service account name."
}

variable "kubernetes_dashboard_deployment_args" {
  type = list(string)
  default = [
    "--enable-insecure-login=true",
  ]
  description = "Kubernetes deployment args."
}
