# Data Files

House rules for Odoo data files — only the decisions an agent cannot infer
from Odoo source code, because the source itself is inconsistent. Everything
else (file formats, CSV conventions, demo data placement) follows standard
Odoo practice: check existing modules when unsure.

## `noupdate` policy

- Wrap in `<data noupdate="1">` the records users are expected to own in
  production: record rules, sequences, crons, operational defaults. An
  upgrade must never reset user-maintained or system-maintained values.
- Keep code-owned records updateable (no noupdate): activities, server
  actions shipped as features — upgrades must be able to deliver
  improvements to them.
- mail templates: it depends, better to ask the user
- `forcecreate` (defaults to `true` in noupdate mode) recreates a record
  the user deleted; set `forcecreate="false"` to respect deletions — rare,
  only for records users may legitimately remove.
- Never rename the xml_id of a noupdate record: existing installs keep the
  old external id and gain a duplicate on update.

## Init hooks and migration scripts

- `post_init_hook` (runs after data loading): use it for records data
  files cannot express — per-company creation loops, values computed from
  other modules' state, ORM operations across modules.
- `pre_init_hook` (before loading): conditionally skip heavy data or
  verify prerequisites.
- `migrations/{module_version}/{pre,post}-migrate.py`: used when the module
  is already installed in a database to migrate existing data.
