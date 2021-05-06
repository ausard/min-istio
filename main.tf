provider "kubernetes" {
    config_path = "~/.kube/config"
    config_context_cluster   = "minikube"
    
 }
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context_cluster   = "minikube"      
  }
}

terraform {
  }
# The module k8s-mesh creates service mesh resources
module "k8s-mesh" {
  source = "./modules/k8s-mesh"
   aws_auth_config_map_id = "Hello" # Dependency on aws_auth configmap
}
module "k8s-monitor" {
  source = "./modules/k8s-monitor"
  aws_auth_config_map_id = "Hello" # Dependency on aws_auth configmap
  kubernetes_dashboard_service_name = module.k8s-dashboard.kubernetes_dashboard_service_name
  kubernetes_dashboard_service_namespace = module.k8s-dashboard.kubernetes_dashboard_service_namespace
  kubernetes_dashboard_view_only_token = module.k8s-dashboard.kubernetes_dashboard_view_only_token
}
module "k8s-core" {
  source = "./modules/k8s-core"
   # Dependency on aws_auth configmap
}
module "k8s-dashboard" {
  source = "./modules/k8s-dashboard"
   # Dependency on aws_auth configmap
}