#!/usr/bin/env bash
# Put a backup from scripts/backup.sh back: the database and the uploads
# folder, both replaced entirely. Then run scripts/setup.sh, which reinstalls
# core and plugins if this is a fresh stack and re-applies the settings.
#
#   scripts/restore.sh                    newest set in ./backups/
#   scripts/restore.sh 20261030-033000    that set
#   scripts/restore.sh --remote [STAMP]   fetch the set from BACKUP_REMOTE first
#   --yes                                 skip the confirmation prompt
source "$(dirname "$0")/lib.sh"

remote=0 yes=0 stamp=""
for arg in "$@"; do
  case "$arg" in
    --remote) remote=1 ;;
    --yes) yes=1 ;;
    -*) echo "Unknown option $arg" >&2; exit 1 ;;
    *) stamp="$arg" ;;
  esac
done

umask 077
mkdir -p backups

if (( remote )); then
  [[ -n "${BACKUP_REMOTE:-}" ]] || { echo "BACKUP_REMOTE is not set in .env." >&2; exit 1; }
  if [[ -z "$stamp" ]]; then
    stamp="$(rclone lsf "$BACKUP_REMOTE" --max-depth 1 --include 'checksums-*.sha256' \
      | sed 's/^checksums-//; s/\.sha256$//' | sort | tail -n1)"
  fi
  [[ -n "$stamp" ]] || { echo "No backups found at $BACKUP_REMOTE." >&2; exit 1; }
  echo "Fetching $stamp from $BACKUP_REMOTE..."
  rclone copy "$BACKUP_REMOTE" /backups --max-depth 1 --include "*-$stamp.*"
fi

if [[ -z "$stamp" ]]; then
  stamp="$(find backups -maxdepth 1 -name 'checksums-*.sha256' | sed 's|.*/checksums-||; s/\.sha256$//' | sort | tail -n1)"
fi
[[ -n "$stamp" ]] || { echo "No backups in ./backups/." >&2; exit 1; }

echo "Checking backup set $stamp..."
(cd backups && sha256sum -c "checksums-$stamp.sha256")

if (( ! yes )); then
  echo "This REPLACES the database '$DB_NAME' and all uploads with the backup from $stamp."
  read -r -p "Type the backup time ($stamp) to continue: " answer
  [[ "$answer" == "$stamp" ]] || { echo "Cancelled."; exit 1; }
fi

wait_for_wordpress

echo "Database <- backups/db-$stamp.sql.gz"
# Recreated, so tables the backup does not have do not survive. The
# application user's grant is by database name and outlives the drop.
docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -uroot -e \
  "DROP DATABASE IF EXISTS \`$DB_NAME\`; CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
gunzip -c "backups/db-$stamp.sql.gz" \
  | docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -uroot "$DB_NAME"

echo "Uploads  <- backups/uploads-$stamp.tar.gz"
docker compose exec -T -u www-data wordpress sh -c \
  'mkdir -p /var/www/html/wp-content/uploads && find /var/www/html/wp-content/uploads -mindepth 1 -delete && tar -C /var/www/html/wp-content -xz' \
  < "backups/uploads-$stamp.tar.gz"

wp cache flush >/dev/null
echo "Restored $stamp. Now run scripts/setup.sh."
