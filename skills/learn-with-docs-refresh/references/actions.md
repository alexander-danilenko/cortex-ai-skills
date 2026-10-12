# Action flows

Follow the flow for each doc's outcome. The main context does all deletions, merges, and metadata edits; only Replace and Split hand writing to a subagent.

## Verify

After writing, merging, or moving any doc, check it per `references/verify-claims.md`: read the doc, read the code it cites, and use `git blame` / `git log` / commit messages where needed. A doc about removed code may cite missing paths — mark them historical rather than deleting them.

## Keep

No edit. One line on why the doc is still trustworthy.

## Update

Fix in place when the solution is still right: a renamed file or module, a broken link, a refreshed snippet after a move, a misfiled doc. Not for style edits, and not when the old fix became an anti-pattern or the architecture changed enough to mislead — that is Replace.

**Relocation.** Move with `git mv`, update `category`, rewrite inbound links (including README rows), then re-check the moved doc's own relative links — they now resolve from a new base. Non-interactive runs relocate only when all four hold: directory and `category` disagree; the content shows the directory is the wrong side; the target directory exists; every inbound link is in-repo and rewritable. Otherwise record it under Recommended with the failing condition.

## Consolidate

1. Pick the canonical doc — broader, more current, more accurate.
2. Merge the other doc's unique content (edge cases, extra prevention rules, other debugging routes) where it belongs, not appended at the end.
3. Repoint links to the subsumed doc. In README catalogs, the canonical doc ends with exactly one row and the subsumed doc with none.
4. Delete the subsumed doc.
5. Verify the canonical doc — merged content brings its citations along.

For 3+ overlapping docs, merge the closest pair first, then reassess.

## Split

Non-interactive: recommend only (doc, proposed fragments, evidence). Interactive, after confirming boundaries:

1. One subagent writes all successors. Pass it the original doc, the fragment boundaries, target paths, and the contents of `references/schema.md` and `assets/resolution-template.md`. Shared context goes into every fragment so each stands alone.
2. Verify each successor.
3. Point each inbound link at the fragment that carries the cited content; update README rows.
4. Delete the original.

## Replace

One at a time. A subagent writes each successor so the main context stays clear.

**Evidence is sufficient:**

1. Spawn one subagent with: the old doc, the investigation evidence (what changed, what the code does now, why the old guidance misleads), the target path and category, and the contents of `references/schema.md` and `assets/resolution-template.md`. It picks `component` and `root_cause` by the corpus-first rule, counting the old doc as part of the corpus.
2. Verify the successor.
3. Delete the old doc and update README rows. The successor may carry `supersedes: <old filename>`.

**Evidence is thin:** stale-mark the doc (`status: stale`, `stale_reason`, `stale_date`), report what was found and what is missing, and suggest capturing a fresh learning next time someone works in that area.

## Delete

Before deleting, search the repo's markdown once more for the filename. Remove decorative citations and README rows in the same change. If a substantive or unclear citation turns up that investigation missed, stop and reclassify: stale-mark (non-interactive) or ask whether Replace fits (interactive).
