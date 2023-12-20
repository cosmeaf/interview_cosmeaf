#!/bin/bash

for i in {1..10}; do
  title="Item $i"
  content="Content $i"
  
  curl -X POST \
    -H "Content-Type: application/json" \
    -d "{\"title\": \"$title\", \"content\": \"$content\"}" \
    http://localhost:3000/posts

  echo "Item $i adicionado."
done

