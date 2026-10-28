# odoo-doc

Consolidated best practices for Odoo development, structured for consumption by
AI coding agents (OpenCode skills, agent context, reviews, audits).

Design principles:

- **Single source of truth**: all knowledge lives in the `odoo-knowledge`
  skill (`skills/odoo-knowledge/references/`). The task skills delegate to it;
  they never duplicate rules.
- **Skills = workflows**: task skills describe *when and how* to apply
  knowledge for a specific task. Knowledge itself lives only in
  `odoo-knowledge`.
- **Versioned knowledge**: version-specific rules live in
  `skills/odoo-knowledge/references/versions/`. Common-to-all-versions rules
  live in the topic files.

## Layout

```text
skills/
├── index.json              HTTP catalog manifest
├── odoo-knowledge/         Shared knowledge base — router + references
│   └── references/         Topic files, migrations/, versions/
├── odoo-review/            Everyday code/PR review workflow
├── odoo-review-oca-migration/  OCA migration/port PR review workflow
├── odoo-audit/             Project audit workflow + report templates
└── odoo-migrate/           Migration knowledge companion
```

## Configuration

### OpenCode

Add to `~/.config/opencode/opencode.json` (or the project `opencode.jsonc`):

```jsonc
{
  "$schema": "https://opencode/config.json",
  "skills": ["~/path/to/odoo-skills/skills"]
}
```

Adjust the path to wherever this repo lives. Every discovered config's
`skills` array entries are combined, so this can be added alongside existing
entries.

### Ensuring the knowledge base is always loaded

Skill activation is model-driven. To guarantee `odoo-knowledge` is loaded for
every Odoo task, add this rule to the `AGENTS.md` of each project where you
develop on Odoo:

```md
## Odoo development

Any task that touches Odoo code (models, fields, views, manifests, security
files, data files, tests, migrations) must start by loading the `odoo-knowledge`
skill and reading the reference file for each area involved.
```

## Maintenance rules

1. Every rule is written once, in `skills/odoo-knowledge/references/`. If a
   skill needs it, the skill delegates to `odoo-knowledge`.
2. Version-specific rules go in `references/versions/<X>.md`, never inline in
   topic files.
3. When a practice is learned (review finding, migration surprise, bug
   post-mortem), propose to record it in the matching reference file.
