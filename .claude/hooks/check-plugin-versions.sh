#!/usr/bin/env bash
# PreToolUse(Bash) gate: block `git commit` unless every plugin touched by the
# commit has a valid semver bump (exactly one patch/minor/major step over HEAD)
# staged in the same commit. Claude picks the level; this script only enforces.
set -euo pipefail

cmd=$(jq -r '.tool_input.command // ""')
[[ $cmd =~ (^|[;\&|[:space:]])git[[:space:]]+([^;\&|]*[[:space:]])?commit([[:space:]]|$) ]] || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}"

all=0
[[ $cmd =~ [[:space:]]--all([[:space:]]|$) || $cmd =~ [[:space:]]-[a-zA-Z]*a[a-zA-Z]*([[:space:]]|$) ]] && all=1

base=HEAD
[[ $cmd =~ --amend ]] && base=HEAD~1
git rev-parse --verify -q "$base" >/dev/null || exit 0

files=$(git diff --cached --name-only)
(( all )) && files+=$'\n'$(git diff --name-only)

plugins=$(printf '%s\n' "$files" | sed -nE 's#^(plugins/[^/]+/[^/]+)/.*#\1#p' | sort -u)
[[ -n $plugins ]] || exit 0

problems=()
while IFS= read -r p; do
  m="$p/.claude-plugin/plugin.json"
  old=$(git show "$base:$m" 2>/dev/null | jq -r .version 2>/dev/null) || continue   # new plugin: nothing to bump
  [[ -n $old && $old != null ]] || continue
  if (( all )); then new=$(jq -r .version "$m" 2>/dev/null) || continue
  else new=$(git show ":$m" 2>/dev/null | jq -r .version 2>/dev/null) || continue; fi   # plugin removed
  # only manifest-only changes (the bump itself) are not a content change
  others=$(printf '%s\n' "$files" | rg -v "^$m\$" | rg -c "^$p/" || true)
  [[ ${others:-0} -gt 0 ]] || continue

  IFS=. read -r a b c <<<"$old"; IFS=. read -r x y z <<<"$new"
  if [[ $new == "$old" ]]; then problems+=("$p: version still $old")
  elif [[ $new != "$a.$b.$((c+1))" && $new != "$a.$((b+1)).0" && $new != "$((a+1)).0.0" ]]; then
    problems+=("$p: $old -> $new is not one patch ($a.$b.$((c+1))), minor ($a.$((b+1)).0) or major ($((a+1)).0.0) step")
  fi
done <<<"$plugins"

((${#problems[@]})) || exit 0

{
  echo "Commit blocked: plugin version bump missing or invalid."
  printf '  - %s\n' "${problems[@]}"
  cat <<'MSG'

For each plugin above:
  1. Read its pending diff: `git diff --cached -- <plugin dir>` (add `git diff -- <plugin dir>` if committing with -a).
  2. Classify the plugin's own diff (highest level wins):
       patch = typos, wording, formatting, config tweaks
       minor = expanded skill content, new references, new/removed skill
       major = rewritten role/workflow, breaking structural change
  3. Edit `version` in <plugin dir>/.claude-plugin/plugin.json by exactly that one step over HEAD.
  4. `git add` that plugin.json, then retry the commit.
Bump each plugin independently; do not bump plugins this commit does not touch.
MSG
} >&2
exit 2
