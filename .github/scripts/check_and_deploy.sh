
#!/bin/bash

# Vérification des paramètres
if [ $# -ne 3 ]; then
  echo "Usage: $0 <COOLIFY_URL> <PROJECT_UUID> <BRANCH_NAME>"
  exit 1
fi

COOLIFY_URL=$1
PROJECT_UUID=$2
BRANCH_NAME=$3

# Vérification de la clé API
if [[ -z "$COOLIFY_API_KEY" ]]; then
  echo "Erreur: La variable COOLIFY_API_KEY n'est pas définie."
  exit 1
fi


# 🔍 Récupération de toutes les ressources
RESOURCES=$(curl -s -X GET "$COOLIFY_URL/api/v1/resources" \
  --header "Authorization: Bearer $COOLIFY_API_KEY" \
  --header "Content-Type: application/json")

echo "$RESOURCES" | grep -oP 'coolify\.environmentName=\K[^\\"]+' | sort | uniq

# # 🔎 Filtrer pour récupérer l'UUID de l'environnement correspondant au nom de la branche
# ENV_UUID=$(echo "$RESOURCES" | jq -r --arg BRANCH "$BRANCH_NAME" '.[] | select(.type == "environment" and .name == $BRANCH) | .uuid')

# if [[ -z "$ENV_UUID" || "$ENV_UUID" == "null" ]]; then
#   echo "❌ Erreur: Aucun environnement avec le nom '$BRANCH_NAME' trouvé dans les ressources."
#   exit 1
# fi

# ✅ Affichage temporaire
echo "ENV_UUID=$ENV_UUID"


# # 🔍 1. Récupération des environnements du projet
# ENV_RESPONSE=$(curl -s -X GET "$COOLIFY_URL/api/v1/projects/$PROJECT_UUID/$BRANCH_NAME" \
#   --header "Authorization: Bearer $COOLIFY_API_KEY" \
#   --header "Content-Type: application/json")

# echo "🔧 Réponse brute de l'environnement :"
# echo "$ENV_RESPONSE"

# # 🔎 2. Extraction de l'UUID de l'environnement correspondant à la branche
# ENV_UUID=$(echo "$ENVIRONMENTS" | jq -r --arg BRANCH "$BRANCH_NAME" '.[] | select(.name == $BRANCH) | .uuid')

# if [[ -z "$ENV_UUID" || "$ENV_UUID" == "null" ]]; then
#   echo "❌ Erreur: L'environnement '$BRANCH_NAME' n'existe pas dans le projet '$PROJECT_UUID'."
#   exit 1
# fi

# # 🔍 3. Récupération des applications
# APPS=$(curl -s -X GET "$COOLIFY_URL/api/v1/applications" \
#   --header "Authorization: Bearer $COOLIFY_API_KEY" \
#   --header "Content-Type: application/json")

# echo ">> DEBUG APPS: $APPS"  # 🔧 DEBUG ICI

# # 🔎 4. Extraction de l'UUID de l'application correspondant à la branche
# APP_UUID=$(echo "$APPS" | jq -r --arg BRANCH "$BRANCH_NAME" '.[] | select(.name == $BRANCH) | .uuid')

# # 🔧 5. Création de l'application si elle n'existe pas
# if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
#   APP_UUID=$(./.github/scripts/create_application.sh "$PROJECT_UUID" "$BRANCH_NAME" "$ENV_UUID")

#   if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
#     echo "❌ Erreur: Échec de la création de l'application."
#     exit 1
#   fi
# fi

# # ✅ Affichage des UUIDs
# echo "APP_UUID=$APP_UUID"
# echo "ENV_UUID=$ENV_UUID"

# # Et pour permettre de les capturer depuis GitHub Actions :
# echo "$APP_UUID|$ENV_UUID"





















# #!/bin/bash

# # Vérification des paramètres
# if [ $# -ne 3 ]; then
#   echo "Usage: $0 <COOLIFY_URL> <PROJECT_UUID> <BRANCH_NAME>"
#   exit 1
# fi

# COOLIFY_URL=$1
# PROJECT_UUID=$2
# BRANCH_NAME=$3

# # Vérification que la variable d'environnement COOLIFY_API_KEY est définie
# if [[ -z "$COOLIFY_API_KEY" ]]; then
#   echo "Erreur: La variable COOLIFY_API_KEY n'est pas définie."
#   exit 1
# fi

# # Récupération de la liste des applications via l'API Coolify
# RESPONSE=$(curl -s -X GET "$COOLIFY_URL/api/v1/applications" \
#   --header "Authorization: Bearer $COOLIFY_API_KEY" \
#   --header "Content-Type: application/json")

# # Vérifier si la requête a réussi
# if [[ -z "$RESPONSE" || "$RESPONSE" == "null" ]]; then
#   echo "Erreur: Impossible de récupérer la liste des applications."
#   exit 1
# fi

# # Extraire l'UUID de l'application correspondant à la branche
# APP_UUID=$(echo "$RESPONSE" | jq -r --arg BRANCH "$BRANCH_NAME" '.[] | select(.name == $BRANCH) | .uuid')

# # Si l'UUID n'a pas été trouvé
# if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
#   # Création de l'application si elle n'existe pas
#   APP_UUID=$(./.github/scripts/create_application.sh "$PROJECT_UUID" "$BRANCH_NAME")

#   # Vérification que l'UUID a bien été créé
#   if [[ -z "$APP_UUID" || "$APP_UUID" == "null" ]]; then
#     echo "Erreur: Échec de la création de l'application."
#     exit 1
#   fi
# fi

# echo "$APP_UUID"

