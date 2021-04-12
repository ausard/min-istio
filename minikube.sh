#!/bin/bash
minikube start --kubernetes-version latest 

# minikube addons enable efk
# minikube addons enable helm-tiller
# minikube addons enable dashboard
# minikube addons enable metallb
# minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable ambassador
kubectl label node minikube worker-class=private
# kubectl create ns kub-blog
# kubectl label ns kub-blog istio-injected=disabled
minikube ip
helm repo update
sh terraform init
terraform apply -auto-approve