#!/bin/bash

# Vérification des paramètres
if [ $# -ne 4 ]; then
  echo "Usage: $0 <PROJECT_UUID> <BRANCH_NAME> <BRANCH_SANITIZE>"
  exit 1
fi

PROJECT_UUID=$1
BRANCH_NAME=$2
BRANCH_SANITIZE=$3
DB_UUID=$4

# 🔐 Vérification de la clé API
if [[ -z "$COOLIFY_API_KEY" ]]; then
  echo "❌ Erreur: La variable COOLIFY_API_KEY n'est pas définie."
  exit 1
fi


# 📦 Appel API pour créer l'application
RESPONSE=$(curl -s -X POST "https://app.coolify.io/api/v1/applications/private-deploy-key" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "project_uuid": "'"$PROJECT_UUID"'",
    "server_uuid": "hc0cok0o4ks0cgc4w8ksgscs",
    "environment_name": "'"$BRANCH_SANITIZE"'",
    "private_key_uuid": "n08ow4so4c084048o8wkws04",
    "git_repository": "https://github.com/Flora24-Yedidya/restful-booker.git",
    "git_branch": "'"$BRANCH_NAME"'",
    "ports_exposes": "8081",
    "build_pack": "dockercompose",
    "name": "'"$BRANCH_NAME"'",
    "docker_compose_location": "docker-compose.yml",
    "instant_deploy": true
  }')

# 🧠 Extraction de l'UUID
APP_UUID=$(echo "$RESPONSE" | jq -r '.uuid')

# ✅ Vérification de l'UUID
if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
  echo "❌ Erreur: Impossible de récupérer l'UUID. Réponse API: $RESPONSE"
  exit 1
fi

# 🚀 Retour de l'UUID
echo "$APP_UUID"
