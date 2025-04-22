#!/bin/bash

# Variables nécessaires
COOLIFY_API_KEY="650|qUSFPJs5qSbfYm0Ek8IPmjSC16K6TZ1uNmsbCxh0fff34c47"
PROJECT_UUID="oo0o044sk8woco480k8occk0"  # UUID du projet
SERVER_UUID="hc0cok0o4ks0cgc4w8ksgscs"  # UUID du serveur
ENVIRONMENT_NAME="feature-pipeline"  # Nom de l'environnement
MARIADB_CONF="W215c3FsZF0KYmluZC1hZGRyZXNzID0gMC4wLjAuMApjaGFyYWN0ZXItc2V0LXNlcnZlciA9IHV0ZjhtYjQKY29sbGF0aW9uLXNlcnZlciA9IHV0ZjhtYjRfdW5pY29kZV9jaQpza2lwLWNoYXJhY3Rlci1zZXQtY2xpZW50LWhhbmRzaGFrZQ=="  # Base64 de mariadb.conf
MARIADB_ROOT_PASSWORD="ofs1"  # Mot de passe root de MariaDB
MARIADB_USER="mariadb"  # Utilisateur MariaDB
MARIADB_PASSWORD="123456"  # Mot de passe de l'utilisateur
DATABASE_NAME="db-feature-pipeline"  # Nom de la base de données
DESCRIPTION="Database pour feature-pipeline"  # Description
IMAGE="mariadb:10.6"  # Image Docker
#hello test
#merci beaucoup


# Récupérer la liste des bases de données existantes dans le projet
EXISTING_DB_UUID=$(curl -s -X GET "https://app.coolify.io/api/v1/databases" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  | jq -r ".[] | select(.name==\"$DATABASE_NAME\") | .uuid")


# Si la DB existe, on la supprime
if [[ -n "$EXISTING_DB_UUID" ]]; then
  echo "Base de données trouvée (UUID: $EXISTING_DB_UUID), suppression..."
  curl -s -X DELETE "https://app.coolify.io/api/v1/databases/$EXISTING_DB_UUID" \
    -H "Authorization: Bearer $COOLIFY_API_KEY"
  echo "Suppression effectuée."
  sleep 5  # On attend quelques secondes pour que la suppression soit bien prise en compte
else
  echo "Aucune base trouvée, on continue."
fi


# Créer une nouvelle base de données
echo "Création de la nouvelle base de données..."

CREATE_DB_RESPONSE=$(curl -s https://app.coolify.io/api/v1/databases/mariadb \
  --request POST \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "server_uuid": "'"$SERVER_UUID"'",
    "project_uuid": "'"$PROJECT_UUID"'",
    "environment_name": "'"$ENVIRONMENT_NAME"'",
    "mariadb_conf": "'"$MARIADB_CONF"'",
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
if [ "$NEW_DB_UUID" != "null" ]; then
  echo "Nouvelle base de données créée avec UUID: $NEW_DB_UUID"
  echo "db_uuid=$NEW_DB_UUID" >> $GITHUB_ENV
else
  echo "Erreur lors de la création de la base de données."
  echo "$CREATE_DB_RESPONSE"
fi
