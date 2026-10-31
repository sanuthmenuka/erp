# Shared helpers for scripts/*. Source it; do not execute directly.
# All scripts are meant to run INSIDE the devcontainer (paths are /workspace/...).

set -euo pipefail

WORKSPACE="${WORKSPACE:-/workspace}"
ODOO_RC="${ODOO_RC:-$WORKSPACE/odoo.conf}"
ODOO_BIN="$WORKSPACE/odoo/odoo-bin"
BACKUP_ROOT="${BACKUP_ROOT:-$WORKSPACE/db/backups}"

if [ ! -f "$ODOO_BIN" ]; then
    echo "error: $ODOO_BIN not found. Run inside the devcontainer, after 'git submodule update --init'." >&2
    exit 1
fi

# Read a key from the [options] section of odoo.conf.
conf() {
    awk -F' *= *' -v k="$1" '$1==k {print $2; exit}' "$ODOO_RC"
}

DB_NAME="${DB_NAME:-$(conf db_name)}"
DATA_DIR="$(conf data_dir)"
export PGHOST="$(conf db_host)" PGPORT="$(conf db_port)" PGUSER="$(conf db_user)" PGPASSWORD="$(conf db_password)"

# shellcheck disable=SC1091
source "$WORKSPACE/.venv/bin/activate"

odoo() {
    python "$ODOO_BIN" -c "$ODOO_RC" "$@"
}

db_exists() {
    [ "$(psql -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$1'")" = "1" ]
}

db_initialized() {
    [ "$(psql -d "$1" -tAc "SELECT to_regclass('public.ir_module_module') IS NOT NULL" 2>/dev/null || echo f)" = "t" ]
}

# Refuse to run DB-changing commands while an Odoo server holds the same DB,
# because the running server would keep stale registry/caches.
warn_if_server_running() {
    if pgrep -f "odoo-bin" >/dev/null 2>&1; then
        echo "warning: an Odoo server seems to be running. Restart it after this command." >&2
    fi
}

git_rev() {
    git -C "$WORKSPACE" rev-parse --short HEAD 2>/dev/null || echo "no-git"
}

git_dirty() {
    if [ -n "$(git -C "$WORKSPACE" status --porcelain 2>/dev/null)" ]; then echo "dirty"; else echo "clean"; fi
}
