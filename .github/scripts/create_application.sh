#!/bin/bash

PROJECT_UUID=$1
BRANCH_NAME=$2

# Appel API pour créer l'application
RESPONSE=$(curl -s -X POST "$COOLIFY_URL/api/v1/applications/private-deploy-key" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "project_uuid": "'"$PROJECT_UUID"'",
    "server_uuid": "g04w4sg0csocwgocwgkgg44k",
    "environment_name": "development",
    "private_key_uuid": "ecokkkckk8cccwgoww00ogg0",
    "git_repository": "git@github.com:devofs2/pro_erpnext.git",
    "git_branch": "'"$BRANCH_NAME"'",
    "ports_exposes": "8081",
    "build_pack": "dockercompose",
    "name": "'"$BRANCH_NAME"'",
    "docker_compose_location": "docker-compose.yml",
    "docker_compose_custom_build_command": "echo '${REGISTRY_PASSWORD}' | docker login ghcr.io -u '${GHRC_OWNER}' --password-stdin && docker pull '${IMAGE_NAME}'",
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
echo "UUID de l'application : $APP_UUID"
