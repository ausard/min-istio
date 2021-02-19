# Ref: https://github.com/istio/istio/blob/master/install/kubernetes/helm/istio/values.yaml
# Ref: https://istio.io/docs/reference/config/installation-options/

# Istio namespace with Istio injection disabled so no sidecars are created for pods in this namespace
resource "kubernetes_namespace" "istio_namespace" {
  metadata {
    name = "istio-system"

    labels = {
      app             = "istio"
      context         = "v1"
      owner           = "gds"
      team            = "enable"
      scope           = "platform"
      department      = "global-digital"
      istio-injection = "disabled"
    }

    
  }

  depends_on = [
    var.aws_auth_config_map_id,
  ]
}
resource "kubernetes_namespace" "istio_operator_namespace" {
  metadata {
    name = "istio-operator"

    labels = {
      app             = "istio-operator"
      context         = "v1"
      owner           = "gds"
      team            = "enable"
      scope           = "platform"
      department      = "global-digital"
      istio-injection = "disabled"
      istio-operator-managed = "Reconcile"
    }


  }


  depends_on = [
    var.aws_auth_config_map_id,
  ]
}
# Use Helm to install Istio Operator
resource "helm_release" "istio_operator" {
  name    = "istio-operator"
  chart   = "${path.module}/charts/istio-operator/"
  version = "1.7.0"
  namespace = kubernetes_namespace.istio_operator_namespace.metadata[0].name

  set {
    name  = "hub"
    value = "docker.io/istio"
  }
  set {
    name  = "tag"
    value = "1.8.2"
  }
  set {
    name  = "operatorNamespace"
    value = kubernetes_namespace.istio_operator_namespace.metadata[0].name
  }

  depends_on = [
    kubernetes_namespace.istio_namespace,
  ]
}

# Use Helm to install Istio
resource "helm_release" "istio" {
  name    = "istio"
  chart   = "${path.module}/charts/istio/"
  version = "1.1.0"
  namespace = kubernetes_namespace.istio_namespace.metadata[0].name
  set {
    name  = "hub"
    value = "docker.io/istio"
  }
  set {
    name  = "tag"
    value = "1.8.2"
  }
  set {
    name  = "operatorNamespace"
    value = kubernetes_namespace.istio_operator_namespace.metadata[0].name
  }

  depends_on = [
    helm_release.istio_operator,
  ]
}
