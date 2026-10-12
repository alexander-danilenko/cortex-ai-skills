# Learning templates

Pick the template for the doc's track (see `references/schema.md`). Keep the section order unless the user asks for another structure. Quote array items per the YAML safety rule.

## Bug track

For `build_error`, `test_failure`, `runtime_error`, `performance_issue`, `database_issue`, `security_issue`, `ui_bug`, `integration_issue`, `logic_error`.

```markdown
---
title: [Clear problem title]
date: [YYYY-MM-DD]
category: [docs/solutions subdirectory]
module: [Module or area]
problem_type: [enum]
component: [corpus value, else suggested default]
symptoms:
  - [Observable symptom]
root_cause: [corpus value, else suggested default]
resolution_type: [enum]
severity: [enum]
retire_when: [optional — omit the line when not needed]
tags: [keyword-one, keyword-two]
---

# [Clear problem title]

## Problem

[1–2 sentences: the issue and its user-visible impact]

## Symptoms

- [Observable symptom or error]

## What Didn't Work

- [Attempted fix and why it failed]

## Solution

[The fix that worked, with code snippets when useful]

## Why This Works

[Root cause and why the fix addresses it]

## Prevention

- [Concrete practice, test, or guardrail]

## Related

- [Related docs or issues, if any]
```

## Knowledge track

For `best_practice`, `documentation_gap`, `workflow_issue`, `developer_experience`, `architecture_pattern`, `design_pattern`, `tooling_decision`, `convention`.

```markdown
---
title: [Clear, descriptive title]
date: [YYYY-MM-DD]
category: [docs/solutions subdirectory]
module: [Module or area]
problem_type: [enum]
component: [corpus value, else suggested default]
severity: [enum]
applies_when:
  - [Condition where this applies]
retire_when: [optional — omit the line when not needed]
tags: [keyword-one, keyword-two]
---

# [Clear, descriptive title]

## Context

[The situation, gap, or friction that prompted this guidance]

## Guidance

[The practice, pattern, or recommendation, with code examples when useful]

## Why This Matters

[Rationale, and the cost of ignoring it]

## When to Apply

- [Condition where this applies]

## Examples

[Concrete before/after or usage examples]

## Related

- [Related docs or issues, if any]
```
