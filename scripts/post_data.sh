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
