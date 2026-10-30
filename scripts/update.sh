#!/usr/bin/env bash
# Bring WordPress core and plugins to the versions pinned in versions.env, and
# refresh translations. Takes a backup first everywhere except local.
#
#   scripts/update.sh --check   list newer releases than the pins (changes nothing)
#   scripts/update.sh           apply versions.env
#
# The routine, at least monthly and for every security release:
#   1. scripts/update.sh --check, on the server or locally
#   2. bump versions.env in a pull request; CI builds and tests that exact set
#   3. merge, then on the server: git pull && scripts/update.sh
#
# The browser cannot update anything (DISALLOW_FILE_MODS) and pulling a newer
# wordpress image does not touch core in the wp_data volume, so this script is
# the only update path.
source "$(dirname "$0")/lib.sh"

wait_for_wordpress

if [[ "${1:-}" == "--check" ]]; then
  echo "Pinned: core $WP_CORE_VERSION, plugins $WP_PLUGINS"
  echo "Newer core releases:"
  wp core check-update --fields=version,update_type || true
  echo "Plugins with updates:"
  wp plugin list --update=available --fields=name,version,update_version
  exit 0
fi

if [[ "${WP_ENVIRONMENT_TYPE:-local}" != "local" && "${SKIP_BACKUP:-0}" != "1" ]]; then
  echo "Backup before updating (SKIP_BACKUP=1 to skip)..."
  "$ROOT/scripts/backup.sh"
fi

echo "Core and plugins (versions.env)..."
apply_pinned_versions

echo "Updating translations..."
wp language core update || warn "Core translation update failed."
wp language plugin update --all || warn "Plugin translation update failed."

wp core version --extra
wp plugin list --fields=name,status,version
