#!/usr/bin/env bash
# Print "<patch-id> <sha>" pairs for the commit SHAs read on stdin (one per
# line). The patch-id is computed on each commit's FULL diff (not restricted
# to any path), so patch-ids from different branches are comparable. Commits
# with an empty diff produce no line.
#
# Usage:
#   git -C <repo> log --format=%H [<rev-args>] | patch-ids.sh <repo>
set -euo pipefail
repo=$1
xargs -r -n 50 git -C "$repo" show | git patch-id --stable
