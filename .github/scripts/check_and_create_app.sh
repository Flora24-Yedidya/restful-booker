#!/bin/bash

# ✅ Vérification des paramètres
if [ $# -ne 3 ]; then
  echo "Usage: $0 <PROJECT_UUID> <BRANCH_NAME> <BRANCH_SANITIZE>"
  exit 1
fi

PROJECT_UUID=$1
BRANCH_NAME=$2  
BRANCH_SANITIZE=$3     
       

# 🔐 Vérification de la clé API
if [[ -z "$COOLIFY_API_KEY" ]]; then
  echo "❌ Erreur: La variable COOLIFY_API_KEY n'est pas définie."
  exit 1
fi

# 🧠 3. On cherche l'UUID de l'application correspondante
APP_RESPONSE=$(curl -s -X GET "https://app.coolify.io/api/v1/applications" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json")

APP_UUID=$(echo "$APP_RESPONSE" | jq -r '.[] | select(.name == "'"$BRANCH_NAME"'") | .uuid')

# 🚀 4. Créer l'application si elle n'existe pas
if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
  APP_UUID=$(./.github/scripts/create_app.sh "$PROJECT_UUID" "$BRANCH_NAME" "$BRANCH_SANITIZE")

  if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
    echo "❌ Erreur: Échec de la création de l'application."
    exit 1
  fi
else
  echo "✅ L'application existe déjà : $APP_UUID"
fi

# 📦 Affichage final
echo "$APP_UUID"
