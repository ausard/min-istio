#!/bin/bash
minikube start --container-runtime=containerd --extra-config=apiserver.service-node-port-range=1-65535 --nodes 2 

minikube addons enable efk
minikube addons enable helm-tiller
minikube addons enable dashboard
minikube addons enable metallb
# minikube addons enable ingress
minikube addons enable metrics-server
# kubectl label node minikube worker-class=private
kubectl create ns kub-blog
# kubectl label ns kub-blog istio-injected=disabled
minikube ip
sh terraform init
terraform apply -auto-approve