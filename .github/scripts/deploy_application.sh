#!/bin/bash

# UUID de l'application
APP_UUID=$1

APP_UUID=$1

if [[ -z "$APP_UUID" ]]; then
  echo "Usage: $0 <APP_UUID>"
  exit 1
fi  

# Requête pour lancer le déploiement de l'application via l'API
curl -X POST "$COOLIFY_URL/api/v1/deploy?uuid=$APP_UUID" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json"

# Afficher un message de confirmation
echo "Déploiement lancé pour l'application avec UUID: $APP_UUID"
