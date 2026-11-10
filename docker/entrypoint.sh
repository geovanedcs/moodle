#!/bin/sh
set -eu
ROLE="${MOODLE_ROLE:-web}"
export MYSQL_PWD="${DB_PASSWORD:?DB_PASSWORD required}"
DB_HOST="${DB_HOST:-db}"
DB_NAME="${DB_NAME:-moodle}"
DB_USER="${DB_USER:-moodle}"

query() {
  mariadb --batch --skip-column-names -h "$DB_HOST" -u "$DB_USER" "$DB_NAME" -e "$1"
}
echo "[moodle] waiting for database"
until query 'SELECT 1' >/dev/null 2>&1; do sleep 3; done

installed() {
  [ "$(query "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name='mdl_config'" 2>/dev/null)" = "1" ]
}

if [ "$ROLE" = cron ]; then
  echo "[moodle] cron role started"
  while :; do
    if installed; then
      su -s /bin/sh www-data -c 'php /var/www/html/admin/cli/cron.php' || echo "[moodle] cron failed"
    fi
    sleep 60
  done
fi

if ! installed; then
  # Refuse to overwrite an existing, partially initialized database.
  TABLE_COUNT="$(query 'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()' | tr -d '[:space:]')"
  if [ "$TABLE_COUNT" != 0 ]; then
    echo "[moodle] database is non-empty but mdl_config is missing; manual recovery required" >&2
    exit 1
  fi
  : "${MOODLE_ADMIN_PASSWORD:?Admin password is required for initial install}"
  : "${MOODLE_ADMIN_EMAIL:?Admin email is required for initial install}"
  : "${MOODLE_URL:?Public URL is required}"
  echo "[moodle] installing Moodle 4.0.12 (first run)"
  # Arguments are visible to privileged process inspectors during installation.
  su -s /bin/sh www-data -c 'php /var/www/html/admin/cli/install_database.php --agree-license --lang=en --adminuser="$MOODLE_ADMIN_USER" --adminpass="$MOODLE_ADMIN_PASSWORD" --adminemail="$MOODLE_ADMIN_EMAIL" --fullname="$MOODLE_SITE_NAME" --shortname="$MOODLE_SITE_SHORTNAME"'
  echo "[moodle] installation complete"
else
  echo "[moodle] existing installation detected; no automatic upgrade or reset"
fi

exec "$@"
