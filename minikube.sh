#!/bin/bash
minikube start
minikube addons enable helm-tiller
minikube addons enable dashboard
minikube addons enable metrics-server
kubectl label node minikube worker-class=private
kubectl create ns kub-blog
kubectl label ns kub-blog istio-injected=disabled
minikube ip