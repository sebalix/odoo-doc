# ORM

House rules for environment, sudo, and transaction handling. Everything
else about the ORM (decorators, computed fields, `Command`, constraints)
follows standard Odoo practice: check modern core modules and `versions/`
when unsure.

## Environment

- Always access through `self.env` (`self.env.cr`, `self.env.uid`,
  `self.env.context`); the legacy attributes (`self._cr`, `self._uid`,
  `self._context`) are removed — see `versions/`.
- Never mutate a context or environment in place: build a new one with
  `with_context()` / `with_user()` / `sudo()` and use that recordset.

## sudo

- `sudo()` only where privileged access is genuinely required, and as
  narrow as possible: latest possible call, smallest recordset.
- Never return a sudo-ed recordset to the web layer (actions, views,
  controllers).
- Prefer `with_user(...)` when the need is a specific user rather than
  bypassed rights.
- Security implications of `sudo` misuse: see `security.md`.

## Transactions

- `cr.commit()` is forbidden in business code: it breaks rollback-on-error
  and partial module upgrades. Justified only in standalone scripts with
  explicit, documented batching.
- Flush pending ORM writes (`flush()`) before raw SQL that reads or
  writes tables the ORM may have modified in-flight.
- Use `with self.env.cr.savepoint():` for error-tolerant partial work
  inside a larger transaction.
