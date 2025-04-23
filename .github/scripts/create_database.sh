#!/bin/bash

# Variables nécessaires
DATABASE_NAME="db-${BRANCH_SANITIZE}"  # Nom de la base de données
DESCRIPTION="Database pour ${BRANCH_SANITIZE}"  # Description
IMAGE="mariadb:10.6"  # Image Docker


# Récupérer la liste des bases de données existantes dans le projet
EXISTING_DB_UUID=$(curl -s -X GET "https://app.coolify.io/api/v1/databases" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  | jq -r ".[] | select(.name==\"$DATABASE_NAME\") | .uuid")


# Si la DB existe, on la supprime
if [[ -n "$EXISTING_DB_UUID" ]]; then
  curl -s -X DELETE "https://app.coolify.io/api/v1/databases/$EXISTING_DB_UUID" \
    -H "Authorization: Bearer $COOLIFY_API_KEY" > /dev/null
  sleep 5  # On attend quelques secondes pour que la suppression soit bien prise en compte
fi


# Créer une nouvelle base de données
CREATE_DB_RESPONSE=$(curl -s https://app.coolify.io/api/v1/databases/mariadb \
  --request POST \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "server_uuid": "'"$SERVER_UUID"'",
    "project_uuid": "'"$PROJECT_UUID"'",
    "environment_name": "'"$BRANCH_SANITIZE"'",
    "mariadb_conf": "W215c3FsZF0KYmluZC1hZGRyZXNzID0gMC4wLjAuMApjaGFyYWN0ZXItc2V0LXNlcnZlciA9IHV0ZjhtYjQKY29sbGF0aW9uLXNlcnZlciA9IHV0ZjhtYjRfdW5pY29kZV9jaQpza2lwLWNoYXJhY3Rlci1zZXQtY2xpZW50LWhhbmRzaGFrZQ==",
    "mariadb_root_password": "'"$MARIADB_ROOT_PASSWORD"'",
    "mariadb_user": "'"$MARIADB_USER"'",
    "mariadb_password": "'"$MARIADB_PASSWORD"'",
    "name": "'"$DATABASE_NAME"'",
    "description": "'"$DESCRIPTION"'",
    "image": "'"$IMAGE"'",
    "instant_deploy": true
}')

# Récupérer le nouvel UUID de la base de données créée
NEW_DB_UUID=$(echo "$CREATE_DB_RESPONSE" | jq -r '.uuid')

# Vérifier si la création a réussi et afficher le nouvel UUID
if [ -z "$NEW_DB_UUID" ] || [ "$NEW_DB_UUID" == "null" ]; then
  echo "Erreur lors de la création de la base de données. Réponse API: $CREATE_DB_RESPONSE"
  exit 1
else
  echo "$NEW_DB_UUID"
fi