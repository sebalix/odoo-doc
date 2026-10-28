# Odoo Migration — Common Patterns

These patterns apply to any module migration, regardless of source/target version.

## Module Structure

| Old | New |
|-----|-----|
| `__openerp__.py` | `__manifest__.py` |
| `migrations/` folder | To remove |

## Manifest

| Old | New |
|-----|-----|
| `installable: False` | `installable: True` |

## XML Views

| Old | New |
|-----|-----|
| `<data noupdate="0">` | `<data>` |

## Migration scripts (openupgradelib)

`openupgradelib` is the OCA support library for migration scripts and
hooks (`pip install openupgradelib`, then
`from openupgradelib import openupgrade`). Pip-level tool: never a
manifest dependency, never business code.

- `@openupgrade.migrate()` decorator on `def migrate(env, version)`:
  bridges `cr` to an env, wraps the run in a savepoint, logs failures
  with script and module context.
- Renames: `rename_xmlids(cr, [...])`, `rename_fields(env, [...])`,
  `rename_columns`, `rename_tables`, `rename_models`,
  `rename_field_references`. Read a value written before a field rename
  through `openupgrade.get_legacy_name('<field>')`.
- Module refactors: `update_module_names`,
  `update_module_moved_fields`, `update_module_moved_models`.
- Data operations: `logged_query(cr, sql, args)` — the replacement for
  raw `cr.execute` in scripts (logs the query and affected rows);
  `load_data` (load XML data during the migration), `map_values`,
  `set_defaults`, `copy_columns`.
- Records: `delete_records_safely_by_xml_id` (removes the record and
  everything pointing at it), `safe_unlink`, `chunked`,
  `update_field_multilang`.
- Schema introspection: `openupgradelib.openupgrade_tools`
  (`table_exists`, `column_exists`, ...). Version-specific helpers live
  in `openupgradelib.openupgrade_140` … `openupgrade_180`.

## Moving records between modules

When records (fields, models, views, access rights, mail templates...)
move from one module to another, re-attribute their XML ids so the
upgrade reuses the existing records instead of dropping columns/tables
and creating duplicates.

- Re-attribute from the **receiving** module, BEFORE its data files
  load: the sending module loads after its dependencies, so its own
  migration runs too late — the duplicate is created already. Use the
  receiver's `pre-migration` (module already installed) or its
  `pre_init_hook` (module not installed yet — migrations never run at
  install).
- Reflection-managed records (`ir.model`, `ir.model.fields`) are reused
  by the model reflection: a delete-stale-if-fresh from the sender's
  migration works, but the reflection then creates a fresh xmlid row and
  the original `create_date` is lost. Rename receiver-side to keep the
  provenance.
- Data records (views, access rights, mail templates...) are re-created
  by the data files: only a receiver-side rename avoids duplicates.
- `rename_xmlids` has no collision guard: renaming a stale xmlid whose
  target twin exists violates the `ir_model_data` unique constraint.
  Drop the stale twins first (scoped to the moved names), avoid
  `allow_merge` (the SQL merge is incomplete, by OCA's own admission)
  and `update_module_moved_fields` (the reflection covers it natively).
- The migration folder runs only when
  `installed_version < folder_version <= manifest_version`: place it at
  the target version only when that version is unreleased; when it
  already reached production, bump the manifest and use the new version.
- `noupdate="1"` records move safely across any load order
  (`_process_end` never garbage-collects them) but still require
  re-attribution — the receiver's data load would create a duplicate
  otherwise.
- Keeping fallback entries in the sending module's migration is
  harmless: on regular upgrades both branches no-op (the receiver
  renamed the rows already), and on selective updates (`-u sender`
  alone) the plain renames apply.

## Verifying an upgrade that moves records

Upgrade a copy of the production database, never production itself,
and assert:

- One record per moved xmlid, under its new module, with the same
  `res_id` and the **original `create_date`**: a recent date means the
  record was re-created — the re-attribution failed.
- No stale xmlid left under the sending module for the moved records.
- Business data intact: row counts and column values unchanged.
- A second update run is a no-op (idempotent).
- Standalone `-i <module>` on a fresh database, for any module whose
  data files gained or lost cross-module references: undeclared
  references crash the data load.
