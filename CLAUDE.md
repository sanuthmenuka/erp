# Notes for AI assistants
Read README.md first. Hard rules:
- Never edit `odoo/` (submodule) or `third-party/`. Extend via `_inherit` in `custom-addons/`.
- Any model/view/data change → bump `version` in that module's `__manifest__.py`, add a CHANGELOG line,
  and add `migrations/<version>/` scripts for data transformations. No ad-hoc SQL.
- Apply with `scripts/odoo-update <module>` (snapshots DB first); test with `scripts/odoo-test <module>`.
- Scripts run inside the devcontainer (`docker exec erp_devcontainer-app-1 bash -lc '...'` from the host).
- Odoo 19 idioms: `models.Constraint` (not `_sql_constraints`), `<list>` (not `<tree>`), `<chatter/>`,
  `res.groups.privilege` for group categories.
- Data model reference: ../docs/ROS_Data_Model.txt
