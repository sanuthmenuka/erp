# QuickBite ERP (Odoo 19 Community)

Restaurant ERP built as custom modules on top of a **pristine** Odoo 19 core.

## Layout

| Path | What | Who edits |
|---|---|---|
| `odoo/` | Odoo 19.0 core, git **submodule** pinned to an exact commit | nobody (bump pointer only) |
| `third-party/odoomates/` | Vendored Odoo Mates accounting/payroll addons (`SOURCE.md`) | nobody (replace on update) |
| `custom-addons/` | Our modules: `quickbite_base`, later `quickbite_menu`, `quickbite_order`, ... | us |
| `templates/module/` | Template used by `odoo-scaffold` | us |
| `scripts/` | Dev commands (on `PATH` in the devcontainer) | us |
| `db/backups/` | DB + filestore snapshots (gitignored) | scripts |
| `.odoo-data/` | Odoo `data_dir`: filestore, sessions (gitignored) | Odoo |
| `odoo.conf` | The only Odoo config; every script uses `-c odoo.conf` | us |

Never change Odoo core or third-party code. Customise with `_inherit` in a `custom-addons` module.

## Setup
1. Open the folder in VS Code → *Reopen in Container* (`post-create.sh` initialises the submodule, venv, pre-commit).
2. `odoo-start` → http://localhost:8069

Fresh clone elsewhere: `git clone --recurse-submodules <repo>` (or `git submodule update --init --depth 1`).

## Commands (run inside the container)

| Command | Does |
|---|---|
| `odoo-start [args]` | Run the server (installs `base` on an empty DB) |
| `odoo-shell` | Odoo Python shell on the dev DB |
| `odoo-scaffold quickbite_xyz` | New module in `custom-addons/` from the template |
| `odoo-install mod[,mod]` | **Snapshot DB**, then install |
| `odoo-update mod[,mod]` | **Snapshot DB**, then upgrade (runs migrations, reloads views/data) |
| `odoo-test mod [--keep]` | Run module tests in a throwaway DB `odoo_test_<mod>` |
| `db-backup [label]` | Manual snapshot → `db/backups/<ts>-<label>/` |
| `db-list-backups` | List snapshots with the git commit they were taken at |
| `db-restore <dir> [db] [--yes]` | Restore a snapshot (drops the target DB) |

## Development workflow

1. **Branch**: `git switch -c feat/menu-items`
2. **Code** in `custom-addons/<module>`. Python changes auto-reload (`dev_mode=reload`); XML/data need step 4.
3. **Bump the manifest version** for every change to models, views, data or security:
   `19.0.<major>.<minor>.<patch>` — new feature → minor, fix → patch, breaking → major.
   Add a line to the module's `CHANGELOG.md`. (The pre-commit hook blocks commits that forget the bump.)
4. **Data transformations** (renames, backfills, splitting fields) go in
   `custom-addons/<module>/migrations/<new version>/{pre,post}-migrate.py` — never as manual SQL.
5. **Apply**: `odoo-update <module>` (automatic snapshot first), restart `odoo-start`.
6. **Test**: `odoo-test <module>`.
7. **Commit** one logical change per commit (`feat(quickbite_menu): ...`, `fix(...)`, `chore(...)`).

## Reverting

Odoo has no "down" migrations, so a rollback = **code revert + DB restore**:

```bash
db-list-backups                       # find the snapshot taken before the change (pre-update-<module>)
git revert <commit>                   # or: git checkout <git hash shown in that snapshot's meta.txt>
db-restore 20261031-120000Z-pre-update-quickbite_base
odoo-start
```

Every snapshot records the git commit (and whether the tree was dirty) in `meta.txt`, so code and DB can always be matched.

Uninstalling a module from *Apps* also removes its tables/data; use it for experiments, then restore a snapshot if needed.

## Upgrading Odoo core (19.0 bug fixes)

```bash
db-backup pre-odoo-core-bump
git -C odoo fetch --depth 1 origin 19.0 && git -C odoo checkout FETCH_HEAD
odoo-update all && odoo-test quickbite_base
git add odoo && git commit -m "chore: bump Odoo 19.0 core to <short hash>"
```

## Third-party addons
See `third-party/odoomates/SOURCE.md`. New third-party code goes into its own `third-party/<vendor>/`
folder with a `SOURCE.md`, plus an entry in `addons_path` in `odoo.conf`.
