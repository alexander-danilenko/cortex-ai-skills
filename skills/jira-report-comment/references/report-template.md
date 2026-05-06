# Report Skeleton for Jira Comment

Use this skeleton when generating the comment. Root Cause is included when the ticket fixes an existing problem. Verify and Deploy are omitted by default - include them ONLY when a Decision Rule in SKILL.md Step 4 is triggered.

---

## <ISSUE_KEY>

One or two sentences describing what shipped, framed as outcome. Do not paraphrase the ticket title, description, or acceptance criteria.

### Root Cause (omit unless ticket fixes a problem)

- The underlying cause (not the symptom from the ticket)
- The approach taken to fix it
- Up to 2 bullets, max 25 words each

### Verify (omit by default)

- Non-obvious test path with expected outcome
- Up to 3 bullets, max 15 words each

### Deploy (omit by default)

- Non-routine deploy step (env var, flag, migration, cron)
- Up to 3 bullets, max 15 words each
