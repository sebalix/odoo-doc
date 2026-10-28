# Testing

How Odoo tests should be organized and written.

## Organization

- Tests live in `tests/`, named `test_<topic>.py` after the model or
  behavior under test (`test_res_partner.py`).
- One class per feature under test; one test method per behavior, named
  `test_<action>__<expected_outcome>`.
- Use `TransactionCase` for standard isolation; only reach for other
  base classes when the test genuinely needs it.
- `@tagged('at_install')` is the default; use `@tagged('post_install')`
  only when the behavior needs the module's *installed* state (data across
  modules, mail templates, ...).
- Tests must not depend on each other's data or on execution order;
  share fixtures and helpers in `tests/common.py`.

## Test data

- Create the data each test needs; never rely on demo data (not installed
  by default from 19.0 on — see `versions/19.0.md`).
- Build the minimal record set that exercises the behavior: heavy setup
  hides what the test is about.
- Mock external services (HTTP, SMTP, ...): tests never reach the
  network.

## What to test

- Business logic: computed values, constraint rejections, state
  transitions, business methods — never Odoo core itself.
- Security: read/write attempts from a limited user (ACL and record rule
  enforcement).
- Regressions: every bug fix ships a test that fails without the fix.
- Assert observable outcomes (field values, raised errors), not
  implementation details.

## Tours (JS)

- A tour test only when the JS behavior itself is under test;
  server-side behavior belongs in normal tests.
- One flow per tour; keep it minimal.
