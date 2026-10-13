#!/usr/bin/env bash
# PostToolUse(Edit|Write|MultiEdit): fix, then validate, the edited markdown file with
# prettier and markdownlint-cli2. Remaining problems go to stderr with exit 2 so Claude fixes them.
# Only ever receives a single .md file, so --fix can't touch non-markdown files.
set -uo pipefail

f=$(jq -r '.tool_input.file_path // ""')
[[ $f == *.md && -f $f ]] || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}"
f=${f#"$PWD"/}
[[ $f == /* || $f == .remember/* || $f == .claude/* || $f == node_modules/* ]] && exit 0

npx -y prettier --write --log-level=silent "$f" >/dev/null 2>&1
npx -y markdownlint-cli2 --fix "$f" >/dev/null 2>&1

out=$(npx -y prettier --check --log-level=warn "$f" 2>&1; npx -y markdownlint-cli2 "$f" 2>&1)
fail=$(npx -y prettier --check --log-level=silent "$f" >/dev/null 2>&1 && npx -y markdownlint-cli2 "$f" >/dev/null 2>&1; echo $?)
[[ $fail == 0 ]] && exit 0
printf 'Markdown lint failed for %s:\n%s\n' "$f" "$out" >&2
exit 2
