#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: $0 <COOLIFY_URL> <COOLIFY_API_KEY> <APP_UUID>"
  exit 1
fi

COOLIFY_URL=$1
COOLIFY_API_KEY=$2
APP_UUID=$3

echo "🔍 Suivi du déploiement pour l'application UUID: $APP_UUID"

for i in {1..30}; do
  echo "⏳ Vérification du statut du déploiement... Tentative $i/30"

  RESPONSE=$(curl -s -H "Authorization: Bearer $COOLIFY_API_KEY" "$COOLIFY_URL/api/v1/applications/$APP_UUID")

  STATUS=$(echo "$RESPONSE" | jq -r '.status')

  echo "📌 Statut actuel: $STATUS"

  if [[ "$STATUS" == "running:healthy" ]]; then
    echo "✅ Application déployée avec succès !"
    echo "deployment_status=success" >> $GITHUB_ENV
    exit 0
  fi

  if [[ "$STATUS" == "running:unhealthy" || "$STATUS" == "error" || "$STATUS" == "failed" ]]; then
    echo "❌ Échec du déploiement !"
    echo "deployment_status=failure" >> $GITHUB_ENV
    exit 1
  fi

  sleep 10
done

echo "⏳ Déploiement trop long ou bloqué."
echo "deployment_status=failure" >> $GITHUB_ENV
exit 1
