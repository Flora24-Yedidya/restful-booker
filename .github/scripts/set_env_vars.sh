#!/bin/bash

APP_UUID=$1
BRANCH_SANITIZE=$2
DB_UUID=$3

curl -X PATCH "https://app.coolify.io/api/v1/application/$APP_UUID" \
  -H "Authorization: Bearer $COOLIFY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "persistentEnvironmentVariables": [
      { "name": "BRANCH_SANITIZE", "value": "'"$BRANCH_SANITIZE"'" },
      { "name": "DB_UUID", "value": "'"$DB_UUID"'" }
    ]
  }'
