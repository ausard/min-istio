locals {
  kubernetes_resources_labels = merge({
    "module" = "k8s-dashboard",
  }, var.kubernetes_resources_labels)

  kubernetes_deployment_labels_selector = {
    "app" = "kubernetes-dashboard",
    "process" = "bootstrap",
    "unit" = "dashboard",
  }

  kubernetes_deployment_labels_selector_metrics = {
    "app" = "kubernetes-dashboard",
    "process" = "bootstrap",
    "unit" = "metrics-scraper",
  }

  kubernetes_deployment_labels = merge(local.kubernetes_deployment_labels_selector, local.kubernetes_resources_labels)
  kubernetes_deployment_labels_metrics = merge(local.kubernetes_deployment_labels_selector_metrics, local.kubernetes_resources_labels)

  kubernetes_deployment_image = "${var.kubernetes_deployment_image_registry}:${var.kubernetes_deployment_image_tag}"
  kubernetes_deployment_metrics_scraper_image = "${var.kubernetes_deployment_metrics_scraper_image_registry}:${var.kubernetes_deployment_metrics_scraper_image_tag}"

  kubernetes_dashboard_viewonly_token = "${lookup(data.kubernetes_secret.get_token_viewonly_secret.data, "token")}"

}