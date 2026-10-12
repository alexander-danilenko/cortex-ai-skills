# Worth audit

Read only after the user confirmed the worth lens. It adds one test on top of the accuracy classification; outcomes and action flows stay the same.

## The bar

A learning earns its place only when it holds reasoning a future engineer could not recover from the final code, tests, types, comments, or existing docs — and losing it would plausibly cause recurrence, real risk, or a substantial re-investigation. Counterfactual: if the doc vanished, would someone reading the implementation still likely repeat the mistake or redo the digging?

This is the bar `learn-with-docs` applies at capture. The worth lens applies it to docs written before the bar, or that grew past it.

## Recoverable means quoted

A claim is recoverable only when a named in-repo artifact states it in its own text: a test assertion or comment, a code comment beside the mechanism, the agent instruction file, a skill reference, or another surviving learning. Topical overlap is not coverage — quote the sentence. A claim no artifact confirms is kept, never treated as recoverable. A doc about a mechanism that no longer exists goes through the normal Delete gate, not this lens.

Add to every investigation subagent's prompt on this path:

> For each claim a reader would need to avoid repeating a mistake or redoing an investigation, search the repository for an artifact whose own text states that reasoning (a test, a code comment, the root agent-instructions file, a skill reference, another learning). Return per claim: recoverable, with the artifact path and quoted sentence — or not recoverable. Do not infer coverage from a file name or topic.

## Routing

Classify for accuracy first; apply this test to docs that survive:

- **Every claim recoverable**, citations absent or decorative → **Delete**. The quotes are the evidence.
- **Some recoverable** → **Update**: cut the recoverable parts, keep measured facts, cross-file invariants, and rejected alternatives nothing else records. Where a reader would look for the cut material, point to the artifact in one line. Narrow the frontmatter to match.
- **Nothing recoverable** → **Keep**.

A doc left with only a session narrative, a change list, or a restatement of a contract another file owns routes to Delete.

**Interactive:** batch broad sweeps and confirm between batches; show each worth-based cut with its quotes. **Non-interactive:** never apply worth-based cuts; list each under Recommended with its quotes. Accuracy-based actions apply as usual.
