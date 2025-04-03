#!/bin/bash

# Vérification des paramètres
if [ $# -ne 3 ]; then
  echo "Usage: $0 <COOLIFY_URL> <PROJECT_UUID> <BRANCH_NAME>"
  exit 1
fi

COOLIFY_URL=$1
PROJECT_UUID=$2
BRANCH_NAME=$3

# Vérification que la variable d'environnement COOLIFY_API_KEY est définie
if [[ -z "$COOLIFY_API_KEY" ]]; then
  echo "Erreur: La variable COOLIFY_API_KEY n'est pas définie."
  exit 1
fi

# Récupération de la liste des applications via l'API Coolify
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

# Si l'UUID n'a pas été trouvé, créer l'application
if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
  # Créer l'application et obtenir le nouvel UUID
  APP_UUID=$(./.github/scripts/create_application.sh "$PROJECT_UUID" "$BRANCH_NAME")

  if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
    echo "Erreur: Échec de la création de l'application."
    exit 1
  fi
fi

# Afficher uniquement l'UUID (c'est la seule sortie du script)
echo "$APP_UUID"
