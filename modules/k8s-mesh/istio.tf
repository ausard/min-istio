# ###################Install Istio (Service Mesh) #######################################
# resource "kubernetes_namespace" "istio_system" {
#   metadata {
#     name = "istio-system"
#   }
# }

# resource "kubernetes_secret" "grafana" {

#   metadata {
#     name      = "grafana"
#     namespace = "istio-system"
#     labels = {
#       app = "grafana"
#     }
#   }
#   data = {
#     username   = "admin"
#     passphrase = "admin"
#   }
#   type       = "Opaque"
#   depends_on = [kubernetes_namespace.istio_system]
# }

# resource "kubernetes_secret" "kiali" {

#   metadata {
#     name      = "kiali"
#     namespace = "istio-system"
#     labels = {
#       app = "kiali"
#     }
#   }
#   data = {
#     username   = "admin"
#     passphrase = "admin"
#   }
#   type       = "Opaque"
#   depends_on = [kubernetes_namespace.istio_system]
# }

# resource "local_file" "istio-config" {
#   content = templatefile("${path.module}/template/istio-eks.tmpl", {
#     enableGrafana = true
#     enableKiali   = true
#     enableTracing = true
#   })
#   filename = ".istio/istio-eks.yaml"
# }

# resource "null_resource" "istio" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = "kubectl apply -f \".istio/istio-eks.yaml\""
#   }
#   depends_on = [kubernetes_secret.grafana, kubernetes_secret.kiali, local_file.istio-config]
# }


# ################### Deploy booking info sample application with gateway  #######################################

# // kubectl provider can be installed from here - https://gavinbunney.github.io/terraform-provider-kubectl/docs/provider.html 
# # data "kubectl_filename_list" "manifests" {
# #     pattern = "samples/bookinfo/*.yaml"
# # }

# # // source of booking info application - https://istio.io/latest/docs/examples/bookinfo/

# # resource "kubectl_manifest" "bookinginfo" {
# #     count = length(data.kubectl_filename_list.manifests.matches)
# #     yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
# # }
resource "kubernetes_namespace" "istio_namespace" {
  metadata {
    name     = "istio-system"

    labels = {
      app = "istio"
      context = "v1"
      owner = "gds"
      team = "enable"
      scope = "platform"
      department = "global-digital"
      istio-injection = "disabled"
    }

    # annotations = {
    #   "cattle.io/status" = "placeholder"
    #   "lifecycle.cattle.io/create.namespace-auth" = "placeholder"
    # }
  }

  # lifecycle {
  #   ignore_changes = [
  #     metadata[0].annotations["cattle.io/status"],
  #     metadata[0].annotations["lifecycle.cattle.io/create.namespace-auth"]
  #   ]
  # }
}
# resource "helm_release" "istio_base" {
#   name       = "istio-base"
#   chart      = "${path.module}/charts/base/"
#   version    = "1.0.0"
#   namespace  = kubernetes_namespace.istio_namespace.metadata.0.name
#   dependency_update = true

#   set {
#     name  = "global.hub"
#     value = "docker.io/istio"
#   }

#   set {
#     name  = "global.tag"
#     value = "1.8.2"
#   }
# depends_on = [ 
#   kubernetes_namespace.istio_namespace,
#    ]  
# }
resource "helm_release" "istio_operator" {
  name       = "istio-operator"
  chart      = "${path.module}/charts/istio-operator/"
  version    = "1.0.0"  
  # dependency_update = true

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
    value = "istio-operator"
  }
  # depends_on = [ helm_release.istio_base ]  
}
resource "null_resource" "istio_delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  triggers = {
    istio_service_name = "istio"
  }
  depends_on = [
    helm_release.istio_operator,
  ]
}
resource "helm_release" "istio" {
  name       = null_resource.istio_delay.triggers.istio_service_name
  chart      = "${path.module}/charts/istio/"
  version    = "1.0.0"
  # dependency_update = true

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
    value = "istio-operator"
  } 
    depends_on = [ helm_release.istio_operator,
     null_resource.istio_delay,
           ]  
}