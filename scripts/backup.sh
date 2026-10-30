#!/usr/bin/env bash
# Back up the database and the uploads folder into ./backups/, copy the set
# off-site when BACKUP_REMOTE is set, and prune old sets on both sides.
# WordPress core and plugins are not included: setup.sh reinstalls them at the
# versions in versions.env. Put a backup back with scripts/restore.sh.
#
# Meant to run unattended (deploy/systemd/eares-backup.timer, or cron): it
# exits non-zero on any failure and pings BACKUP_PING_URL only on success, so
# a monitor notices when backups silently stop.
source "$(dirname "$0")/lib.sh"

# The dump holds members' emails, phone numbers and password hashes.
umask 077
mkdir -p backups

# One backup at a time: a slow run and the next timer tick must not interleave.
exec 9> backups/.lock
if command -v flock >/dev/null && ! flock -n 9; then
  echo "Another backup is running." >&2
  exit 1
fi

stamp="$(date +%Y%m%d-%H%M%S)"
db="db-$stamp.sql.gz" uploads="uploads-$stamp.tar.gz" sums="checksums-$stamp.sha256"
# Written under .partial names and renamed once complete, so pruning, the
# off-site copy and restore.sh never see half a file.
trap 'rm -f backups/*.partial' EXIT

echo "Database -> backups/$db"
docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db \
  mariadb-dump -uroot --single-transaction --default-character-set=utf8mb4 "$DB_NAME" \
  | gzip > "backups/$db.partial"
gzip -t "backups/$db.partial"
mv "backups/$db.partial" "backups/$db"

echo "Uploads  -> backups/$uploads"
docker compose exec -T -u www-data wordpress \
  sh -c 'mkdir -p /var/www/html/wp-content/uploads && tar -C /var/www/html/wp-content -cz uploads' \
  > "backups/$uploads.partial"
tar -tzf "backups/$uploads.partial" >/dev/null
mv "backups/$uploads.partial" "backups/$uploads"

(cd backups && sha256sum "$db" "$uploads" > "$sums")
ls -lh "backups/$db" "backups/$uploads"

if [[ -n "${BACKUP_REMOTE:-}" ]]; then
  echo "Off-site -> $BACKUP_REMOTE"
  rclone copy /backups "$BACKUP_REMOTE" --include "*-$stamp.*"
  # Only our own files at the top level, never anything else in the bucket.
  rclone delete "$BACKUP_REMOTE" --max-depth 1 --min-age "${BACKUP_REMOTE_KEEP_DAYS:-90}d" \
    --include 'db-*.sql.gz' --include 'uploads-*.tar.gz' --include 'checksums-*.sha256'
else
  warn "BACKUP_REMOTE is not set: this backup exists only on this machine."
fi

keep="${BACKUP_KEEP_DAYS:-14}"
find backups -maxdepth 1 -type f -mtime +"$keep" \
  \( -name 'db-*.sql.gz' -o -name 'uploads-*.tar.gz' -o -name 'checksums-*.sha256' \) \
  -print -delete | sed 's/^/  pruned /'

if [[ -n "${BACKUP_PING_URL:-}" ]]; then
  curl -fsS -m 10 --retry 3 -o /dev/null "$BACKUP_PING_URL" || warn "Could not ping BACKUP_PING_URL."
fi
