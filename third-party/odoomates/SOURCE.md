# Odoo Mates addons (vendored)

| | |
|---|---|
| Origin | https://github.com/odoomates/odooapps (branch `19.0`) |
| Vendored on | 2026-10-31 (moved out of `odoo/addons/`, where they had been copied manually) |
| License | LGPL-3 (see each module's manifest) |

| Module | Manifest version | Installed in dev DB |
|---|---|---|
| accounting_pdf_reports | 1.0.2 | yes |
| om_account_accountant | 1.0.3 | yes |
| om_account_asset | 1.0.0 | yes |
| om_account_budget | 1.0.1 | yes |
| om_account_daily_reports | 1.0.1 | yes |
| om_account_followup | 1.0.2 | yes |
| om_fiscal_year | 1.0.1 | yes |
| om_recurring_payments | 1.0.0 | yes |
| om_hr_payroll | 19.0.1.0 | no |
| om_hr_payroll_account | 19.0.0.0 | no |

## Rules
- **Do not edit these files.** Customise behaviour from a `custom-addons/` module with `_inherit`.
- To update: replace the module folder(s) with the new upstream copy in a single commit
  titled `chore(third-party): update odoomates <modules> to <version>`, update the table
  above, then run `odoo-update <modules>` (which snapshots the DB first).
