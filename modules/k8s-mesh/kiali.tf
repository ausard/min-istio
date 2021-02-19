# https://github.com/kiali/helm-charts/tree/master/kiali-operator

resource "kubernetes_namespace" "kiali_operator_namespace" {
  metadata {
    name = "kiali-operator"

    labels = {
      app             = "kiali-operator"
      context         = "v1"
      owner           = "gds"
      team            = "enable"
      scope           = "platform"
      department      = "global-digital"
      istio-injection = "disabled"
    }

    annotations = {
      "cattle.io/status"                          = "placeholder"
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

resource "helm_release" "kiali_operator" {
  name       = "kiali-operator"
  chart      = "kiali-operator"
  version    = "1.29.0"
  repository = "https://kiali.org/helm-charts"
  namespace  = kubernetes_namespace.kiali_operator_namespace.metadata[0].name

  set {
    name  = "cr.create"
    value = "true"
  }
  set {
    name  = "cr.namespace"
    value = kubernetes_namespace.istio_namespace.metadata[0].name
  }

  values = [
    templatefile("${path.module}/config/kiali-operator.yaml", {
    #   KIALI_URL = "https://internal.${local.gd_tf_workspace}.gds.bose.com/kiali",
      }
    )
  ]
  depends_on = [
    helm_release.istio,
  ]
}
