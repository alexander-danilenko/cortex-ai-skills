#!/usr/bin/env bash
# Format and validate markdown files.
#
# Usage:
#   ./lint.sh                # fix and validate all markdown
#   ./lint.sh "path/glob"    # fix and validate a path or glob (quote globs!)
#   ./lint.sh --check        # validate only, no fixes (CI / pre-merge)
#
# Pipeline:
#   1. Fix      — prettier --write, then markdownlint-cli2 --fix.   Silent.
#   2. Validate — prettier --check, then markdownlint-cli2.         Loud.
#
# Both validators always run so you see every problem in one pass.
# Exit code is non-zero if either validator fails.
set -euo pipefail

CHECK_ONLY=0
if [ "${1:-}" = "--check" ]; then
  CHECK_ONLY=1
  shift
fi
TARGET="${1:-**/*.md}"

if [ "$CHECK_ONLY" -eq 0 ]; then
  npx -y prettier --write --log-level=silent "$TARGET" >/dev/null 2>&1 || true
  npx -y markdownlint-cli2 --fix "$TARGET" >/dev/null 2>&1 || true
fi

FAIL=0

echo "→ prettier"
npx -y prettier --check --log-level=warn "$TARGET" || FAIL=1

echo "→ markdownlint"
npx -y markdownlint-cli2 "$TARGET" || FAIL=1

exit "$FAIL"
