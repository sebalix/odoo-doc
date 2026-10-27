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
