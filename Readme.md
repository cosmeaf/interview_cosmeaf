# Passo a Passo para Implantação

##### Este guia fornece instruções para criar uma imagem Docker, configurar um cluster Kubernetes, fazer redirecionamento para a aplicação web, criar um contêiner MySQL e implantar sua aplicação web e banco de dados MySQL no cluster Kubernetes.

### 1. Criando a Imagem Docker

Primeiro, crie a imagem Docker da sua aplicação:

```
docker build -t interview_image:1.0.2 .
docker scan interview_image:1.0.2
docker tag interview_image:1.0.2 cosmeaf/interview_image:1.0.2
docker push cosmeaf/interview_image:1.0.2
docker pull cosmeaf/interview_image:1.0.2

```

### 2. Criando o Cluster Kubernetes

Você pode escolher entre o Docker ou o VirtualBox como driver para o Minikube. Certifique-se de selecionar o driver desejado e criar o cluster:

```
# Usando Docker como driver
minikube start --wait=false --driver=docker --no-vtx-check

# Usando VirtualBox como driver
minikube start --wait=false --driver=virtualbox --no-vtx-check

# Verifique o estado dos pods no cluster
minikube kubectl -- get pods -A

# Crie um namespace para o cluster (opcional)
kubectl create namespace kube-webapp-cluster

# Configure o contexto atual para o namespace criado (opcional)
kubectl config set-context --current --namespace=kube-webapp-cluster

```

### 3. Configurando o Redirecionamento

Habilite o Ingress no Minikube e defina o redirecionamento para o serviço da aplicação web:

```
# Habilite o addon Ingress
minikube addons enable ingress

# Obtenha a URL do serviço da aplicação web
minikube service --url webapp-service-loadbalancer

# Opção 1: Sem especificar um endereço IP público
kubectl port-forward service/webapp-service-loadbalancer 3000:3000

# Opção 2: Especificando um endereço IP público
IP_PUBLICO=$(curl -4 -s ifconfig.me)
kubectl port-forward service/webapp-service-loadbalancer 3000:3000 --address $IP_PUBLICO

```

### 4. Criando o Contêiner MySQL

Agora, crie um contêiner MySQL com volume persistente e uma tabela de migração:

```
# Crie um volume Docker para o MySQL
sudo docker volume create mysql_vol

# Execute o contêiner MySQL
docker run -it -p 3306:3306 \
 --name mysql \
 -e MYSQL_ROOT_PASSWORD=test \
 -e MYSQL_DATABASE=test \
 -e MYSQL_USER=test \
 -e MYSQL_PASSWORD=test \
 --restart unless-stopped \
 -v mysql_vol:/var/lib/mysql \
 -d mariadb:5.5

# Acesse o shell do contêiner MySQL
docker exec -it mysql bash -l
mysql -utest -ptest

# Crie uma tabela de migração no banco de dados "test"
USE test;

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`timestamp` bigint(20) NOT NULL,
`name` varchar(255) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

```

### 5. Criando o Cluster Kubernetes (novamente)

Crie novamente o cluster Kubernetes para implantar sua aplicação web e o banco de dados MySQL:

```
# Usando Docker como driver (caso ainda não tenha criado)
minikube start --driver=docker

# Usando VirtualBox como driver (caso ainda não tenha criado)
minikube start --wait=false --driver=virtualbox --no-vtx-check

# Liste os perfis do Minikube (opcional)
minikube profile list

# Aplique as configurações do Deployment e dos serviços da aplicação web
kubectl apply -f deployment.yaml

```

### 6. Obtendo IP Dinâmico para Acesso à Aplicação

Você pode usar o script a seguir para adicionar itens à sua aplicação e obter o IP da aplicação web:

```
#!/bin/bash

HOST=$(minikube service --url webapp-service-loadbalancer)

for i in {1..10}; do
  title="Item $i"
  content="Content $i"

  curl -X POST \
   -H "Content-Type: application/json" \
   -d "{\"title\": \"$title\", \"content\": \"$content\"}" \
   "$HOST"

  echo "Item $i adicionado."
done

# Liste os perfis do Minikube (opcional)
minikube profile list

# Liste os contextos do Kubernetes (opcional)
kubectl config get-contexts

# Verifique o estado dos pods (opcional)
kubectl get pods

# Verifique os serviços (opcional)
kubectl get services

```

### 7. Excluindo o Cluster Kubernetes

Após concluir o uso do cluster, você pode excluí-lo usando o seguinte comando:

### 8. Sobre os Arquivos YAML

Os arquivos YAML que você compartilhou cobrem uma ampla gama de configurações necessárias para implantar uma aplicação web e um banco de dados MySQL no Kubernetes. Certifique-se de que as configurações nos arquivos estão corretas antes de aplicá-las no cluster.

Espero que este guia seja útil para implantar sua aplicação web e banco de dados MySQL no Kubernetes. Certifique-se de revisar e personalizar os arquivos YAML de acordo com suas necessidades específicas.
