# Migrations

Odoo runs these automatically during `odoo-update quickbite_base` when the
manifest `version` is bumped past the folder name:

```
migrations/
└── 19.0.1.1.0/
    ├── pre-migrate.py    # before the module's models/data are loaded (rename columns, etc.)
    ├── post-migrate.py   # after load (backfill / transform data via ORM)
    └── end-migrate.py    # after ALL modules are updated
```

Each file defines `def migrate(cr, version):` (`version` = previously installed version).
There are no "down" migrations: rollback = `db-restore` the snapshot that
`odoo-update` takes automatically, plus `git revert` of the code.
