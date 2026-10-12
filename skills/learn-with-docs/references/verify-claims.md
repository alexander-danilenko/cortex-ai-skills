# Verify claims

A learning becomes trusted knowledge: the next agent acts on it without re-checking. So before it lands, check every factual claim against the repo by reading, not from memory of the session.

## How

1. **Read the doc** and list its checkable claims: cited paths, code behavior (values, defaults, limits, ordering, state transitions), commits and PRs, links, and counts ("three root causes").
2. **Read the related code** at the current tree for each behavior claim. Find the defining lines and confirm the doc says what they do.
3. **Dig into history when the code alone does not explain it** — why a line exists, when it changed, whether a fix actually landed:

   ```bash
   git log --oneline -n 20 -- <path>        # recent changes to a file
   git blame -L <start>,<end> <path>        # who/what last touched these lines
   git show <sha>                           # the commit message and diff
   git log -S '<symbol>' --oneline          # when a symbol appeared or vanished
   gh pr view <number> --json state,mergedAt,title   # did the PR merge
   ```

   Commit messages and PR descriptions often carry the reasoning a learning should capture — use them to sharpen the doc, not just to verify it.

4. **Check links and paths**: relative links resolve from the doc's directory; every cited path exists, or the prose says it was removed ("deleted by this fix").

## Resolve what you find

| Finding | Do |
| --- | --- |
| Code does something else | Fix the doc from the code — the code wins over the conversation |
| Claim cannot be confirmed | Soften ("per this session's investigation…") or drop it |
| Path gone because this fix removed it | Keep it, marked as historical |
| Path or link wrong | Fix it |
| Commit hash cited | Prefer the PR number — rebase and squash rewrite hashes |
| Fix not merged yet | Say so: "fix in #123, unmerged as of YYYY-MM-DD" |
| Count does not match the items listed | Complete the list or fix the count |
| Drafting leftovers (`Learning 3`, `{{…}}`) | Remove |

A claim the repo cannot witness (an ops practice, an environment quirk) is not false — keep it and note that it is unverified.

Apply the same check to any `CONCEPTS.md` entry added or edited this run.

## Frontmatter

Validate it against `assets/learning.schema.json` (required fields, enums, track rules, tag format). The YAML parser also rejects an unquoted value with a colon followed by a space:

```bash
f="$(mktemp).yaml"
awk 'NR==1{if($0!="---")exit 1;next} /^---$/{exit} {print}' <doc-path> > "$f" || echo "no frontmatter"
npx -y @sourcemeta/jsonschema validate "<this skill's directory>/assets/learning.schema.json" "$f"
```

For the whole store, extract every doc's frontmatter into one temp directory and validate that directory in one call:

```bash
d="$(mktemp -d)"
find docs/solutions -name '*.md' ! -name README.md | while read -r doc; do
  awk 'NR==1{if($0!="---")exit 1;next} /^---$/{exit} {print}' "$doc" > "$d/$(echo "$doc" | tr / _).yaml"
done
npx -y @sourcemeta/jsonschema validate "<this skill's directory>/assets/learning.schema.json" "$d"
```

Fix what fails and re-run. Two things the validator cannot see, so check them by eye: a value with a space followed by `#` parses fine but loses everything after it, and `component`/`root_cause` must follow the corpus-first rule in `references/schema.md`. Without Node, check the same rules by reading the frontmatter against `references/schema.md`.

## Report line

One line: claims checked, fixed, softened, and any left unverified.
