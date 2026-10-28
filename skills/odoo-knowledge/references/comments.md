# Comments and Docstrings

House rules for what a linter cannot judge: the *usefulness* of a
comment or docstring. Style and formatting are not covered — run the
tools instead.

## Usefulness

- Comment only what the code does not say: intent, rationale, non-obvious
  consequences, cross-model contracts. Never restate adjacent code, a
  method name, or the docstring above.
- Docstrings document contracts: business rules, expected formats, what
  the caller gets. Lists of field names and walkthroughs of the body are
  not contracts.
- No environment commentary (which module is installed in production,
  which is not, what the database state is) when the mechanism already
  implies it: an `{pre,post}_init_hook` means the module is not installed,
  a migration script means it is.

## Refactoring

- When code moves, its comments move with it and keep their wording:
  judge only the comments the change newly adds, never the pre-existing
  ones.
- A refactoring commit that extracts business code must justify its own
  additions only — trimming moved comments is out of scope and silently
  reverts the author's choices.
