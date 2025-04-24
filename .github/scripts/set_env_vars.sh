#!/bin/bash

APP_UUID=$1
BRANCH_SANITIZE=$2
DB_UUID=$3


echo "Sending vars to Coolify:"
echo "BRANCH_SANITIZE: $BRANCH_SANITIZE"
echo "DB_UUID: $DB_UUID"

JSON_PAYLOAD=$(cat <<EOF
{
  "persistentEnvironmentVariables": [
    { "name": "BRANCH_SANITIZE", "value": "$BRANCH_SANITIZE" },
    { "name": "DB_UUID", "value": "$DB_UUID" }
  ]
}
EOF
)

echo "JSON payload: $JSON_PAYLOAD"

curl -X PATCH "https://app.coolify.io/api/v1/applications/$APP_UUID" \
  -H "Authorization: Bearer $COOLIFY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD"





#curl -X PATCH "https://app.coolify.io/api/v1/applications/$APP_UUID" \
#  -H "Authorization: Bearer $COOLIFY_API_KEY" \
#  -H "Content-Type: application/json" \
#  -d '{
#    "persistentEnvironmentVariables": [
#      { "name": "BRANCH_SANITIZE", "value": "'"$BRANCH_SANITIZE"'" },
#      { "name": "DB_UUID", "value": "'"$DB_UUID"'" }
#    ]
#  }'
