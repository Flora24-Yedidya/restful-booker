#!/bin/bash

PROJECT_UUID=$1
BRANCH_NAME=$2

# Appel API pour créer l'application
RESPONSE=$(curl -s -X POST "$COOLIFY_URL/api/v1/applications/private-deploy-key" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "project_uuid": "'"$PROJECT_UUID"'",
    "server_uuid": "b00kw00wk4kw40gck0owg0s0",
    "environment_name": "test",
    "environment_uuid": "tsowoc8s880848wwk80gok8c",
    "private_key_uuid": "p8800wog404c044wkgok0o48",
    "git_repository": "https://github.com/Flora24-Yedidya/restful-booker.git",
    "git_branch": "'"$BRANCH_NAME"'",
    "ports_exposes": "8081",
    "build_pack": "dockercompose",
    "name": "test/port",
    "docker_compose_location": "docker-compose.yml",
    "docker_compose_custom_build_command": "echo $REGISTRY_PASSWORD | docker login ghcr.io -u devofs2 --password-stdin && docker pull ghcr.io/devofs2/pro_erpnext_feature-cicd:latest",
    "docker_compose_custom_start_command": "docker compose up -d",
    "manual_webhook_secret_github": "hello",
    "instant_deploy": true
  }')

# Extraire l'UUID de la réponse
APP_UUID=$(echo "$RESPONSE" | jq -r '.uuid')

# Vérifier si l'UUID est bien récupéré
if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
  echo "Erreur: Impossible de récupérer l'UUID. Réponse API: $RESPONSE"
  exit 1
fi

# Retourner l'UUID
echo "$APP_UUID"