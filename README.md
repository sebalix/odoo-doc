# odoo-doc

Consolidated best practices for Odoo development, structured for consumption by
AI coding agents (OpenCode skills, agent context, reviews, audits).

Design principles:

- **Single source of truth**: all knowledge lives in `docs/`. Skills reference
  the docs; they never duplicate rules.
- **Skills = workflows**: skills describe *when and how* to apply knowledge for
  a specific task. Knowledge itself is not embedded in skills.
- **Versioned knowledge**: version-specific rules live in `docs/versions/`.
  Common-to-all-versions rules live in the topic files.

## Layout

```text
skills/
├── index.json              HTTP catalog manifest
├── odoo-review/            Everyday code/PR review workflow
├── odoo-audit/             Project audit workflow + report templates
└── odoo-migrate/           Migration knowledge companion
docs/
├── index.md                Navigation map — start here
├── *.md                    Topic best practices
├── migrations/             Version-agnostic migration patterns
└── versions/               Per-version migration deltas (13.0 → 19.0)
```

## Configuration

Add to `~/.config/opencode/opencode.json` (or the project `opencode.jsonc`):

```jsonc
{
  "$schema": "https://opencode/config.json",
  "skills": ["~/dev/odoo-doc/skills"]
}
```

Adjust the path to wherever this repo lives. Every discovered config's
`skills` array entries are combined, so this can be added alongside existing
entries.

## Maintenance rules

1. Every rule is written once, in `docs/`. If a skill needs it, the skill
   points to the doc.
2. Version-specific rules go in `docs/versions/<X>.md`, never inline in
   topic files.
3. Prefer enforcing rules with tooling (pre-commit, linters) over documenting
   them; agents run the tools instead of re-deriving their findings.
4. When a practice is learned (review finding, migration surprise, bug
   post-mortem), record it in the matching `docs/` file.
