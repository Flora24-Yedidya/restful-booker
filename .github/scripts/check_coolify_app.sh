#!/bin/bash

# Vérification des paramètres
if [ $# -ne 2 ]; then
  echo "Usage: $0 <COOLIFY_URL> <BRANCH_NAME>"
  exit 1
fi

COOLIFY_URL=$1
BRANCH_NAME=$2

# Appel API pour récupérer la liste des applications
RESPONSE=$(curl -s -X GET "$COOLIFY_URL/api/v1/applications" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json")

# Vérifier si la requête a réussi
if [[ -z "$RESPONSE" || "$RESPONSE" == "null" ]]; then
  echo "Erreur: Impossible de récupérer la liste des applications."
  exit 1
fi

# Extraire l'UUID de l'application correspondant à la branche
APP_UUID=$(echo "$RESPONSE" | jq -r --arg BRANCH "$BRANCH_NAME" '.[] | select(.name == $BRANCH) | .uuid')

# Vérifier si l'UUID a été trouvé
if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
  echo "Aucune application trouvée pour la branche: $BRANCH_NAME"
  exit 1
fi

# Afficher l'UUID trouvé
echo "Application trouvée: UUID = $APP_UUID"
