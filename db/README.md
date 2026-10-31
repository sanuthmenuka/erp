# Database rules

1. **No ad-hoc SQL or manual "fix" scripts against the dev/prod DB.**
   Every schema or data change lives in a module, so it's in git and replayable:
   - new fields/models → Python models (Odoo creates columns)
   - configuration/master data → `data/*.xml` (use `noupdate="1"` for records users may edit)
   - transforming existing data → `migrations/<version>/pre|post-migrate.py` + manifest version bump
2. **Apply changes only through `odoo-install` / `odoo-update`** — they snapshot first.
3. `odoo-shell` is for inspection. If you do change data there, take `db-backup` first and turn
   whatever you did into a migration script afterwards.
4. `backups/` is gitignored (size + it may contain real data). Copy important snapshots off the
   machine if they matter. Each snapshot = `odoo.dump` (pg_dump -Fc), `filestore.tar.gz`,
   `installed_modules.txt`, `meta.txt` (git commit, Odoo core commit, date).

Snapshot `20261031-105026-pre-restructure` is the state before this repo was set up.
