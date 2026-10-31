# Changelog (repository / infrastructure)

Module-level changes are in `custom-addons/<module>/CHANGELOG.md`.

## 2026-10-31 - Repository setup
- Git repository created; Odoo 19.0 core tracked as submodule pinned at `9188766f`.
- Odoo Mates addons moved out of core into `third-party/odoomates/`.
- `odoo.conf` single source of config; filestore moved to `.odoo-data/`.
- Snapshot-first DB scripts (`db-backup`, `db-restore`, `odoo-install`, `odoo-update`, `odoo-test`).
- `quickbite_base` module (outlets, order-type settings, security groups).
- ruff (Odoo rules) + pre-commit, module template.
- Pre-change DB snapshot: `db/backups/20261031-052026Z-pre-restructure`.
