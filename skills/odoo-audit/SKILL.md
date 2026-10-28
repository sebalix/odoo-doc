---
name: odoo-audit
description: Perform a systematic audit of an Odoo project or module set — architecture, security, data model, performance, and upgrade readiness. Use when asked to audit, assess, or run a health check on an Odoo codebase. For reviewing a single change or PR, use the odoo-review skill instead.
---

## Workflow

1. **Inventory**: list the modules (manifests), their dependencies, the
   target Odoo version(s), and the overall project layout. Record what is
   custom vs. OCA/standard.
2. Load the `odoo-knowledge` skill — its routing table maps each area below
   to its reference file.
3. **Per-area assessment**: for each area below, read the matching
   odoo-knowledge reference *before* assessing, then sweep the codebase for
   the patterns the file flags and judge every hit against its rules — a hit
   is not a finding by itself; the rules say what makes it one. The
   assessment of an area is complete when every pattern has been swept and
   every hit judged. Record findings with severity (blocker / should-fix /
   nit) and `file:line` evidence:

   - Module structure & dependencies
   - Models & ORM
   - Security
   - Data files
   - Tests

4. **Upgrade readiness**: assess against the odoo-knowledge version
   reference for the next Odoo version, and its common migration patterns.
5. **Report**: produce the final report following
   `references/report-template.md`.

## Coverage rules

- Do not skip an area because it "looks fine" — assess each one explicitly,
  even if only to record "no findings".
- Prefer evidence (file paths, line numbers) over generalities.
- Distinguish findings in custom code from findings in unmodified
  OCA/standard modules; the latter usually call for an upstream fix or an
  override, not a local patch.
