# Criando Cluster Kubernate

minikube start --wait=false --driver=docker --nodes=2 --no-vtx-check
minikube kubectl -- get pods -A
kubectl create namespace kube-webapp-cluster
kubectl config set-context --current --namespace=kube-webapp-cluster

kubectl create configmap migration-script --from-file=./scripts/create_data.sql

kubectl delete -f k8s/
kubectl apply -f k8s/

minikube addons enable ingress

kubectl port-forward service/webapp-service 3000:3000

# Exclude Cluster Kubernate

minikube delete -p minikube

# Debug

minikube kubectl -- get pods -A
kubectl get pods -l app=webapp -n kube-webapp-cluster
kubectl logs -l app=webapp -n kube-webapp-cluster
kubectl describe pod -l app=webapp -n kube-webapp-cluster
kubectl describe service webapp-service -n kube-webapp-cluster

# Reiniciando PODs

kubectl delete pods -l app=webapp -n kube-webapp-cluster

# Sobre Os arquivos YML

Os arquivos YAML que você compartilhou cobrem uma ampla gama de configurações necessárias para implantar uma aplicação web e um banco de dados MySQL no Kubernetes. Vou fazer uma rápida revisão de cada um para garantir que estão corretamente configurados e prontos para uso:

app-deployment.yaml

Este arquivo define um Deployment para sua aplicação web. As variáveis de ambiente estão configuradas para conexão com um banco de dados MySQL.
Inclui configurações de recursos e sondas de saúde (liveness e readiness probes).
app-hpa.yaml

Define um Horizontal Pod Autoscaler para o seu Deployment da aplicação web.
Escala com base na utilização de CPU. Porém, o scaleTargetRef deve referenciar o nome correto do Deployment, que é webapp, e não webapp-deployment.
app-service.yaml

Configura um Service do tipo ClusterIP para a aplicação web, permitindo comunicação dentro do cluster Kubernetes.
ingress.yaml

Define regras de Ingress para o serviço da aplicação web.
O nome do serviço no backend deve corresponder ao nome definido no Service da aplicação web (webapp-service).
mysql-deployment.yaml

Cria um Deployment para o banco de dados MySQL.
Inclui configuração de ambiente e montagem de volume para persistência de dados.
mysql-pvc.yaml

Define um PersistentVolumeClaim para o MySQL, garantindo armazenamento persistente.
mysql-service.yaml

Configura um Service para o MySQL, facilitando a comunicação com o banco de dados dentro do cluster.
Pod MySQL
