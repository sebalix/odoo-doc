---
name: odoo-review
description: Review Odoo module code, diffs, or pull requests for correctness, security, performance, and conventions. Use when asked to review Odoo code, or when a change touches Odoo models, views, security files, or manifests. For OCA migration/port PRs, prefer the review-oca-migration-pr skill instead.
---

## Workflow

1. Determine the target Odoo version from the module (`__manifest__.py`
   version, branch name, or the `odoo/odoo` git remote). It decides which
   version rules apply.
2. Read `../../docs/index.md`, then the topic files matching the touched
   areas (e.g. `../../docs/orm.md`, `../../docs/security.md`). Read only
   what is relevant to the diff.
3. Read `../../docs/versions/<version>.md` for version-specific pitfalls
   that could affect the change.
4. Check each file in the diff against the applicable rules. Skip style
   issues a linter would catch (pre-commit, flake8, eslint) — focus on what
   tools cannot check.
5. Classify every finding:
   - **Blocker**: security hole, data corruption risk, crash, broken behavior.
   - **Should-fix**: convention violation, maintainability or performance issue.
   - **Nit**: minor style or preference; optional to address.
6. Report each finding with `file:line`, the rule violated, and a suggested
   fix. End with a verdict: approve / approve with comments / request changes.

## Quick checklist

- Manifest: version consistent, dependencies declared, license set.
- Models: `@api.depends` complete, decorator order correct,
  computed/inverse pairs coherent.
- Security: `ir.model.access.csv` complete, `ir.rule` where multi-company or
  record isolation applies, no unparameterized SQL, `sudo()` justified.
- Views: inheritance via xpath, unique view ids, `groups` set where required.
- User-facing strings translatable.
- New behavior covered by tests.
