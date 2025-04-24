#!/bin/bash
set -e

APP_UUID=$1
BRANCH_SANITIZE=$2
DB_UUID=$3

echo "Sending vars to Coolify:"
echo "BRANCH_SANITIZE: $BRANCH_SANITIZE"
echo "DB_UUID: $DB_UUID"

JSON_PAYLOAD=$(jq -n \
  --arg bs "$BRANCH_SANITIZE" \
  --arg db "$DB_UUID" \
  '{
    data: [
      { key: "BRANCH_SANITIZE", value: $bs, is_build_time: true, is_literal: true },
      { key: "DB_UUID", value: $db, is_build_time: true, is_literal: true }
    ]
  }'
)

echo "JSON payload:"
echo "$JSON_PAYLOAD"

curl -X PATCH "https://app.coolify.io/api/v1/applications/$APP_UUID/envs/bulk" \
  -H "Authorization: Bearer $COOLIFY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD"
