# Investigate and classify

## Investigate

For each doc, check what goes stale independently:

- Referenced paths, classes, modules, and code snippets.
- The recommended solution itself — does it still match how the code works?
- Cross-referenced docs. For a knowledge-track doc that names or links a guidance file (a skill's `SKILL.md`, a runbook, an instruction file), read that file and note whether it states a different order or rule for the same procedure — and which side current code follows. Compare only guidance the doc names; never go looking for one.
- Overlap with other in-scope docs: which pairs cover the same problem, files, or solution, and which is broader or more current.
- Domain terms: is each project-specific term defined accurately in `CONCEPTS.md`, and does each in-scope entry still name a concept the project has? Collect only; edit in the vocabulary step.
- **`retire_when`**: when a doc declares one, check whether the condition is now met through the source it names (issue tracker, release notes, a pinned version). Record the result and date in the report, not in the doc. Never infer a condition for a doc that declares none.

Match depth to specificity: a doc citing exact paths and snippets needs more checking than a general principle. If the host injects persistent memory notes, treat same-domain notes as prompts to look harder, never as evidence on their own.

Then look at the set: overlaps, supersession (a newer doc subsumes an older narrow one), and contradictions between docs or between a doc and guidance it names. Note category-shape problems (a directory mixing unrelated themes, a near-empty one) as report-only observations.

**Subagents.** Small scopes run in the main context. For 3+ independent docs, run read-only investigation subagents in parallel; investigate overlapping docs together. Each returns evidence and a recommended outcome; the main context decides and does all writes and deletions. Paste into each subagent's prompt:

> Investigate this learning against the current codebase using file search and read tools. Return evidence for each claim (file:line quotes) and a recommended outcome. If the learning is knowledge-track and names or links a guidance file, read it, and when it states a different order or contradictory rule for the same procedure, return both quotes and which side current code follows — or that code witnesses neither. Read only guidance the learning names. Do not edit anything.

## Outcomes

| Outcome | Meaning | Action |
| --- | --- | --- |
| **Keep** | Still accurate and useful | No edit. Report as reviewed — no "last reviewed" stamp. |
| **Update** | Solution still right; references drifted (paths, names, links, snippets, metadata, misfiling) | Fix in place |
| **Consolidate** | Docs overlap heavily, both correct | Merge unique content into the canonical doc, delete the other |
| **Replace** | Guidance now misleads, and a trustworthy successor can be written | Subagent writes the successor, then delete the old doc |
| **Delete** | No longer useful, applicable, or distinct | Delete the file |

## Judgment rules

- **Drift vs. regression.** Claims about current mechanics follow current code — fix the doc. But guidance with independent evidence that it still governs stays intact when code stops following it; report the conflict as a possible regression.
- **Update vs. Replace.** Changing what the doc recommends is Replace, not Update. When a doc and a guidance file it names disagree: if the guidance is right, Replace the doc; if the doc is right, recommend fixing the guidance (never edit it); if code supports neither, ask (interactive) or stale-mark and report.
- **Replace needs real evidence** — from the investigation, the conversation, newer docs or PRs, or the user. Without it, stale-mark and suggest capturing a fresh learning with `learn-with-docs` next time someone works in that area.
- **A met `retire_when`** is contradicting evidence: classify from it. If the repo still carries the workaround the doc explains, the doc stays and removing the workaround is the recommended action. An unmet or uncheckable condition decides nothing.
- **Consolidate or keep separate?** Would someone searching this topic in six months be helped by separate docs (different sub-problems, audiences), or do they only add drift risk? Two accurate docs about different sub-problems stay separate even when they cite the same file. A subsumed doc with nothing unique is a straight Delete.
- **Split** (one doc → focused successors) is rare: only when each fragment has independent search value and readers of one are hurt by wading through the others. Length alone is never a reason.
- **Relocate** (an Update) only when directory and `category` disagree or the content plainly belongs in another existing category. Decide the direction from the content; never create a category directory to relocate into.
- **Pattern docs** (`docs/solutions/patterns/`) are derived guidance: judge them by the refreshed learnings beneath them, after those learnings. A pattern with no supporting learnings is a stale signal.

## Before any Delete

1. **Is the problem still live?** Missing files prove the implementation is gone, not the problem. If the app still deals with what the doc addresses, it is Replace. A doc that never referenced in-repo code (environment, onboarding, process) never auto-deletes.
2. **Inbound links.** Search the repo's markdown for the filename. Decorative citations (see-also pointers) allow Delete with cleanup in the same commit. Substantive ones (the citing doc relies on it) mean Replace or a narrowed Keep. Unclear → stale-mark or ask.

**Auto-delete** without asking, in either mode, only when all three hold: the implementation lived in this repo and is gone (or the doc is fully superseded or redundant); the problem is gone — or the surviving doc already states this doc's specific guidance (topical overlap is not coverage); and inbound citations are absent or decorative.

## When to ask (interactive)

Ask only when: the outcome is genuinely ambiguous; a Delete fails the auto-delete gate; the canonical doc of a Consolidate is unclear; or before any Replace or Split. Show the path, 2–4 evidence bullets, and the recommended action, plus plausible alternatives and "skip for now".
