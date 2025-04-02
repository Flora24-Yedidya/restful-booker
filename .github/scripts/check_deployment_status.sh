#!/bin/bash

# Vérification des paramètres
if [ $# -ne 3 ]; then
  echo "Usage: $0 <COOLIFY_URL> <COOLIFY_API_KEY> <APP_UUID>"
  exit 1
fi

COOLIFY_URL=$1
COOLIFY_API_KEY=$2
APP_UUID=$3

# Début du suivi du déploiement
echo "🔍 Suivi du déploiement pour l'application UUID: $APP_UUID"

# Vérification de l'état du déploiement
for i in {1..30}; do
  echo "⏳ Vérification du statut du déploiement... Tentative $i/30"

  # Appel API pour récupérer le statut de l'application
  RESPONSE=$(curl -s -H "Authorization: Bearer $COOLIFY_API_KEY" "$COOLIFY_URL/api/v1/applications/$APP_UUID")

  # Extraction du statut avec `jq`
  STATUS=$(echo "$RESPONSE" | jq -r '.status')

  echo "📌 Statut actuel: $STATUS"

  # Si l'application est bien déployée
  if [[ "$STATUS" == "running:healthy" ]]; then
    echo "✅ Application déployée avec succès !"
    echo "deployment_status=success" >> $GITHUB_ENV
    exit 0
  fi

  # Si l'application a un statut d'erreur
  if [[ "$STATUS" == "running:unhealthy" || "$STATUS" == "error" || "$STATUS" == "failed" ]]; then
    echo "❌ Échec du déploiement !"
    echo "deployment_status=failure" >> $GITHUB_ENV
    exit 1
  fi

  # Attendre 10 secondes avant la prochaine vérification
  sleep 10
done

# Si après 30 essais l'application n'est pas `running:healthy`, on considère que c'est un échec
echo "⏳ Déploiement trop long ou bloqué."
echo "deployment_status=failure" >> $GITHUB_ENV
exit 1
