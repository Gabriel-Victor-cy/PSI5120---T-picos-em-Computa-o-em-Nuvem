#!/bin/bash
set -e

echo "🚀 Iniciando Minikube..."
minikube start --driver=docker

echo "📦 Habilitando metrics-server..."
minikube addons enable metrics-server
kubectl wait --for=condition=Available -n kube-system deployment/metrics-server --timeout=180s

echo "📜 Aplicando manifests..."
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml
kubectl apply -f manifests/hpa.yaml

echo "✅ Implantação concluída!"
kubectl get all
