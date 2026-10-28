# Odoo Project Audit Report

<!-- Fill every section; write "No findings" explicitly when an area is clean. -->

## 1. Executive summary

- Project / scope audited:
- Odoo version(s):
- Audit date:
- Overall assessment: <!-- one paragraph: health, main risks, top priorities -->
- Headline numbers: X blockers, Y should-fix, Z nits; N modules
  (M custom), E person-days estimated to migrate to the latest stable.

## 2. Scope & inventory

- Modules audited (custom vs. OCA/standard):
- Out of scope:
- Detailed inventory: `module-inventory.csv` — one row per module
  (origin, upstream, LOC, availability, migration effort).

### Inventory summary

<!-- One row per origin, totals from module-inventory.csv. -->

| Origin | Modules | Python LOC | Total LOC | Est. migration days |
|--------|---------|-----------|-----------|---------------------|
| odoo-core | | | | |
| odoo-enterprise | | | | |
| oca | | | | |
| third-party | | | | |
| custom | | | | |
| **Total** | | | | |

## 3. Findings summary

<!-- One table row per finding, grouped by severity. -->

| # | Severity | Area | Module | Finding | Evidence |
|---|----------|------|--------|---------|----------|

## 4. Detailed findings per area

### 4.1 Module structure & dependencies
### 4.2 Models & ORM
### 4.3 Security
### 4.4 Views
### 4.5 Data files
### 4.6 Performance
### 4.7 Tests
### 4.8 Tooling coverage

<!-- For each finding: description, evidence (file:line), impact, recommended fix. -->

## 5. Upgrade readiness

- Target version assessed:
- Version deltas affecting this codebase:
- Estimated migration effort: per-module days in `module-inventory.csv`;
  summarize the main cost drivers (modules, deltas) and the total here.

## 6. Prioritized action plan

1. <!-- blockers first, with suggested owner and effort -->
