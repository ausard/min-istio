data "kubernetes_service_account" "get_token_viewonly_sa" {
  metadata {
    name = kubernetes_service_account.kubernetes_dashboard_viewonly.metadata.0.name
    # name = "kubernetes-dashboard-viewonly"
    namespace = var.kubernetes_dashboard_namespace
  }
  depends_on = [kubernetes_service_account.kubernetes_dashboard_viewonly]
}

data "kubernetes_secret" "get_token_viewonly_secret" {
  metadata {
    name = "${data.kubernetes_service_account.get_token_viewonly_sa.default_secret_name}"
    namespace = var.kubernetes_dashboard_namespace
  }  
}
data "template_file" "mapping" {
  template = "${file("${path.module}/mapping.tpl")}"
  vars = {
    token = "${local.kubernetes_dashboard_viewonly_token}"
    namespace =  "${var.kubernetes_dashboard_namespace}"
    service_name = "${kubernetes_service.kubernetes_dashboard.metadata.0.name}"
  }
}
