# Ref: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
# Ref: https://github.com/prometheus-operator/prometheus-operator
# Ref: https://github.com/prometheus-operator/kube-prometheus
# Kube-prometheus-stack namespace with Istio injection disabled so no sidecars are created for pods in this namespace
resource "kubernetes_namespace" "kube_prometheus_stack_namespace" {
  metadata {
    name     = "monitoring"

    labels = {
      app = "kube-prometheus-stack"
      owner = "gds"
      team = "enable"
      scope = "platform"
      context = "v1"
      istio-injection = "disabled"
    }

    annotations = {
      "cattle.io/status" = "placeholder"
      "lifecycle.cattle.io/create.namespace-auth" = "placeholder"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["cattle.io/status"],
      metadata[0].annotations["lifecycle.cattle.io/create.namespace-auth"]
    ]
  }

  depends_on = [
    var.aws_auth_config_map_id,
  ]
}

# Helm release Kube-prometheus-stack
resource "helm_release" "kube_prometheus_stack" {
  name       = "monitoring"
  chart      = "kube-prometheus-stack"
  version    = "14.0.0"
  repository = "https://prometheus-community.github.io/helm-charts/"
  namespace  = kubernetes_namespace.kube_prometheus_stack_namespace.metadata.0.name
  dependency_update = true

  values = [
    templatefile("${path.module}/config/kube-prometheus-stack.yaml", {
      # ADMIN_PWD = jsondecode(data.aws_secretsmanager_secret_version.grafana.secret_string)["adminPassword"],
      # ROOT_URL = "https://external.${local.gd_tf_workspace}.gds.bose.com/grafana",
      # GRAFANA_REPLICA =  var.grafana_replica,
      # GRAFANA_MAX_PDB = var.grafana_max_pdb,
      # SPRING_DASHBOARD_LINK = "https://${aws_s3_bucket.grafana_dashboards.bucket_domain_name}/dashboards/spring-boot-statistics.json",
      # SPRING_DASHBOARD = local.spring_dashboard,

      ADMIN_PWD = "admin",
      ROOT_URL = "",
      GRAFANA_REPLICA =  1,
      GRAFANA_MAX_PDB = 1
      SPRING_DASHBOARD_LINK = "https://gds-dev-grafana.s3-eu-west-1.amazonaws.com/dashboards/spring-boot-statistics.json",
      SPRING_DASHBOARD = local.spring_dashboard,
    }
    )
  ]
}
