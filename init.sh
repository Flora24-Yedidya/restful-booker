#!/bin/bash
set -e

SITE_NAME=${SITE_NAME:-site1.local}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}
DB_ROOT_USER=${DB_ROOT_USER:-root}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-admin}
INSTALL_APPS="pibicut payments erpnext"

cd /home/frappe/frappe-bench

echo "🔍 SITE_NAME=$SITE_NAME"
echo "🔍 DB_HOST=$DB_HOST"

if [ ! -d "sites/$SITE_NAME" ]; then
  echo "🔧 Creating site $SITE_NAME..."
  bench new-site "$SITE_NAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --db-root-username "$DB_ROOT_USER" \
    --db-root-password "$DB_ROOT_PASSWORD" \
    --set-default

  for APP in $INSTALL_APPS; do
    echo "📦 Installing $APP..."
    bench --site "$SITE_NAME" install-app "$APP"
  done

  echo "🚀 Migrating site..."
  bench --site "$SITE_NAME" migrate

  echo "✅ Enabling scheduler..."
  bench --site "$SITE_NAME" enable-scheduler
else
  echo "✅ Site $SITE_NAME already exists. Skipping creation."
fi

exec bench start
