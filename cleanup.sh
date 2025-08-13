#!/bin/bash
set -euo pipefail

echo "🧹 Removendo recursos do namespace default..."
kubectl delete -f manifests/ || true

echo "🗑️ Excluindo cluster EKS (isso demora)..."
eksctl delete cluster --name my-eks-hpa --region us-east-1
