# PSI5120---T-picos-em-Computa-o-em-Nuvem
Compilado de códigos para os exercícios propostos na disciplina PSI5120

# Kubernetes HPA no Minikube

Este repositório demonstra a implantação de um servidor web (`php-apache`) com autoscaling horizontal (HPA) usando métricas de CPU, rodando em um cluster local Minikube.

## 📌 Pré-requisitos
- Ubuntu 22.04 LTS
- Minikube
- kubectl

## 🚀 Passos rápidos

1. Iniciar o Minikube:
```bash
minikube start --driver=docker
```

2. Habilitar metrics-server:
```bash
minikube addons enable metrics-server
kubectl wait --for=condition=Available -n kube-system deployment/metrics-server --timeout=180s
```

3. Criar Deployment, Service e HPA:
```bash
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml
kubectl apply -f manifests/hpa.yaml
```

4. Gerar carga para testar o autoscaling:
```bash
kubectl run -it --rm load-generator --image=busybox --restart=Never -- /bin/sh -c 'while true; do wget -q -O- http://php-apache.default.svc.cluster.local/; done'
```

5. Observar o HPA:
```bash
watch -n 2 kubectl get hpa
```

## 🧹 Limpeza
```bash
kubectl delete -f manifests/
```





# Kubernetes HPA no AWS EKS

Este repositório demonstra a implantação de um servidor web (`php-apache`) com autoscaling horizontal (HPA) usando métricas de CPU em um cluster **AWS EKS**.

## 📌 Pré-requisitos
- Ubuntu 22.04 LTS
- AWS CLI configurada (`aws configure`)
- `kubectl`
- `eksctl`

## 🚀 Passos rápidos

1) Criar o cluster EKS:
```bash
eksctl create cluster -f manifests/eks-cluster.yaml
```

2) Instalar o metrics-server (add-on gerenciado):
```bash
eksctl create addon --name metrics-server --cluster my-eks-hpa --region us-east-1 --force
kubectl -n kube-system rollout status deployment/metrics-server --timeout=5m
```

3) Criar Deployment, Service e HPA:
```bash
kubectl apply -f manifests/deployment.yaml
kubectl apply -f manifests/service.yaml
kubectl apply -f manifests/hpa.yaml
```

4) Gerar carga para testar o autoscaling:
```bash
kubectl run -it --rm load-generator --image=busybox --restart=Never -- /bin/sh -c 'while true; do wget -q -O- http://php-apache.default.svc.cluster.local/; done'
```

5) Observar o HPA:
```bash
watch -n 2 kubectl get hpa
```

## 🌐 (Opcional) Expor externamente com LoadBalancer
```bash
kubectl expose deploy/php-apache --type=LoadBalancer --name=php-apache-lb --port=80 --target-port=80
kubectl get svc php-apache-lb -w
```

## 🧹 Limpeza
```bash
kubectl delete -f manifests/
eksctl delete cluster --name my-eks-hpa --region us-east-1
```
