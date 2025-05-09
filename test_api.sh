#!/bin/bash

BASE_URL="http://localhost:3000/api"
EMAIL="user1@example.com" 
PASSWORD="password123"

echo "🔐 Login..."
RESPONSE=$(curl -s -X POST $BASE_URL/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\", \"password\":\"$PASSWORD\"}")

TOKEN=$(echo $RESPONSE | jq -r '.token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "❌ Falha no login ou credenciais inválidas."
  echo "Resposta: $RESPONSE"
  exit 1
fi

echo "✅ Token obtido: $TOKEN"

echo -e "\n📊 Testando /dashboard..."
curl -s -X GET $BASE_URL/dashboard \
  -H "Authorization: Bearer $TOKEN" | jq

echo -e "\n🛫 testando /aeroportos..."
curl -s -X GET $BASE_URL/aeroportos | jq

echo -e "\n📍 Testando /aeroportos/origem/GRU..."
curl -s -X GET $BASE_URL/aeroportos/origem/GRU | jq

echo -e "\n📅 Testando /voos..."
HOJE=2025-06-03
curl -s -X GET "$BASE_URL/voos?data=$HOJE" | jq

echo -e "\n🚪 Testando logout..."
curl -s -X POST $BASE_URL/logout \
  -H "Authorization: Bearer $TOKEN" | jq

echo -e "\n✅ Teste finalizado."
