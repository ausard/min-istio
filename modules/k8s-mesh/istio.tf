# Ref: https://github.com/istio/istio/blob/master/install/kubernetes/helm/istio/values.yaml
# Ref: https://istio.io/docs/reference/config/installation-options/
# Ref: https://github.com/istio/istio/tree/1.4.3/install/kubernetes/helm/istio
# Ref: https://github.com/istio/istio/tree/1.4.3

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

# Kiali kubernetes secret for basic authentication
resource "kubernetes_secret" "kiali_secret" {
  metadata {
    name      = "kiali"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
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

  data = {
    username   = "admin"
    passphrase = "gdsadmin"
  }

  type = "Opaque"

  depends_on = [
    var.aws_auth_config_map_id,
  ]
}

# Grafana kubernetes secret for basic authentication
resource "kubernetes_secret" "grafana_secret" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
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

  data = {
    username   = "admin"
    passphrase = "gdsadmin"
  }

  type = "Opaque"

  depends_on = [
    var.aws_auth_config_map_id,
  ]
}

# Use Helm to install Istio Init
resource "helm_release" "istio_init" {
  name       = "istio-init"
  repository = "https://storage.googleapis.com/istio-release/releases/1.4.3/charts/"
  chart      = "istio-init"
  version    = "1.4.3"
  namespace  = kubernetes_namespace.istio_namespace.metadata.0.name

  depends_on = [
    kubernetes_namespace.istio_namespace,
  ]
}

# Add a delay for Istio Init to fully complete and trigger the next helm_release
resource "null_resource" "istio_delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  triggers = {
    istio_service_name = "istio"
  }
  depends_on = [
    helm_release.istio_init,
  ]
}

# Use Helm to install Istio
resource "helm_release" "istio" {
  name              = null_resource.istio_delay.triggers.istio_service_name
  chart             = "istio"
  version           = "1.4.3"
  repository        = "https://storage.googleapis.com/istio-release/releases/1.4.3/charts/"
  namespace         = kubernetes_namespace.istio_namespace.metadata.0.name
  dependency_update = true
  timeout           = 600

  values = [
    templatefile("${path.module}/config/istio.yaml", {})
  ]

  depends_on = [
    helm_release.istio_init,
    null_resource.istio_delay,
    kubernetes_namespace.istio_namespace,
  ]
}
