# Fallbacks without `gh`

Use these only when `gh` is unavailable or unauthenticated (`gh auth status`
fails), after cloning the PR ref as in section 0 of the skill. The
unauthenticated REST API is limited to 60 requests/hour.

## PR metadata

```bash
curl -s "https://api.github.com/repos/OCA/$REPO/pulls/$N" -o /tmp/odoo-review-oca-migration/pr.json
python3 - <<'PY'
import json
d = json.load(open("/tmp/odoo-review-oca-migration/pr.json"))
print("title:", d["title"])
print("author:", d["user"]["login"], "| draft:", d["draft"], "| state:", d["state"], "| merged:", d["merged"])
print("base:", d["base"]["ref"], "| head:", d["head"]["ref"], "| head_repo:", (d["head"]["repo"] or {}).get("full_name"))
print("commits:", d["commits"], "| changed_files:", d["changed_files"], "| mergeable_state:", d["mergeable_state"])
print("body:\n" + (d.get("body") or ""))
PY
```

## CI check-runs

```bash
curl -s "https://api.github.com/repos/OCA/$REPO/commits/$PR_SHA/check-runs?per_page=100" -o /tmp/odoo-review-oca-migration/checks.json
python3 - <<'PY'
import json
runs = json.load(open("/tmp/odoo-review-oca-migration/checks.json")).get("check_runs", [])
if not runs:
    print("no CI checks found")
for c in runs:
    print(f'{c["name"]}: {c["status"]}/{c["conclusion"]}')
PY
```

## PR commit list

For an open PR use `PR_RANGE="origin/$TARGET..pr-$N"`; for a merged PR (that
range is empty, head is an ancestor of TARGET) use the merge commit
`M=$(git -C "$WORK" log "origin/$TARGET" --format=%H --grep="#$N" -1)` and
`PR_RANGE="$M^1..$M^2"`. Then write the list in the same format:

```bash
git -C "$WORK" log --reverse --no-merges --format='%H %s' "$PR_RANGE" \
  > /tmp/odoo-review-oca-migration/pr-commits.txt
```
