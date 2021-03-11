# https://github.com/aws/amazon-vpc-cni-k8s/blob/master/config/v1.5/calico.yaml
# https://kubernetes.io/docs/concepts/services-networking/network-policies/
# Helm release Calico
resource "helm_release" "calico" {
  name       = "calico"
  chart      = "${path.module}/charts/calico/"
  version    = "1.0.0"
  namespace  = "kube-system"
  dependency_update = true

  # depends_on = [ module.k8-mesh.helm_release.istio ]
}
