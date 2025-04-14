#!/bin/bash

# ✅ Vérification des paramètres
if [ $# -ne 3 ]; then
  echo "Usage: $0 <PROJECT_UUID> <BRANCH_SANITIZE> <BRANCH_NAME>"
  exit 1
fi

PROJECT_UUID=$1
BRANCH_SANITIZE=$2     # ex: feature-cicd
BRANCH_NAME=$3         # ex: feature/cicd

# 🔐 Vérification de la clé API
if [[ -z "$COOLIFY_API_KEY" ]]; then
  echo "❌ Erreur: La variable COOLIFY_API_KEY n'est pas définie."
  exit 1
fi

# 🔍 1. Récupération des ressources
RESOURCES=$(curl -s -X GET "https://app.coolify.io/api/v1/resources" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json")

# 🔎 2. Extraction de l'environnement (en cherchant dans les labels)
ENV_NAME=$(echo "$RESOURCES" | grep -oP 'coolify\.environmentName=\K[^\\"]+' | grep -F "$BRANCH_SANITIZE" | head -n 1)

if [[ -z "$ENV_NAME" ]]; then
  echo "❌ Erreur: Aucun environnement avec le nom '$BRANCH_SANITIZE' trouvé dans les ressources."
  exit 1
fi
echo "✅ Environnement trouvé: $ENV_NAME"

# 🧠 3. On cherche l'UUID de l'application correspondante
APP_RESPONSE=$(curl -s -X GET "https://app.coolify.io/api/v1/applications" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json")

APP_UUID=$(echo "$APP_RESPONSE" | jq -r '.[] | select(.name == "'"$BRANCH_NAME"'") | .uuid')

# 🚀 4. Créer l'application si elle n'existe pas
if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
  echo "📦 Application '$BRANCH_NAME' non trouvée. Création en cours..."
  APP_UUID=$(./.github/scripts/create_application.sh "$PROJECT_UUID" "$BRANCH_NAME" "$ENV_NAME" "$BRANCH_SANITIZE")

  if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
    echo "❌ Erreur: Échec de la création de l'application."
    exit 1
  fi
else
  echo "✅ L'application '$BRANCH_NAME' existe déjà : $APP_UUID"
fi

# 📦 Affichage final
echo "APP_UUID=$APP_UUID"
