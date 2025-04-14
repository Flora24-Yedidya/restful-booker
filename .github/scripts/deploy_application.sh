#!/bin/bash

# UUID de l'application et nom de l'application CI/CD
APP_UUID=$1
APP_NAME=$BRANCH_NAME

if [[ -z "$APP_UUID" || -z "$APP_NAME" ]]; then
  echo "Usage: $0 <APP_UUID> <APP_NAME>"
  exit 1
fi  

# Requête pour lancer le déploiement de l'application via l'API
RESPONSE=$(curl -s -X POST "https://app.coolify.io/api/v1/deploy?uuid=$APP_UUID" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json")
  
# Vérifier si la requête a réussi
if [[ "$RESPONSE" == *"error"* ]]; then
  echo "Erreur lors du déploiement de l'application: $RESPONSE"
  exit 1
fi

# Afficher un message de confirmation
echo "Déploiement lancé sur la branche $APP_NAME"
