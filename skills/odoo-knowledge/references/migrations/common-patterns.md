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
