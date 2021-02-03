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
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}
# The module k8s-mesh creates service mesh resources
module "k8s-mesh" {
  source = "./modules/k8s-mesh"
   aws_auth_config_map_id = "Hello" # Dependency on aws_auth configmap
}
module "k8s-monitor" {
  source = "./modules/k8s-monitor"
  aws_auth_config_map_id = "Hello" # Dependency on aws_auth configmap
}