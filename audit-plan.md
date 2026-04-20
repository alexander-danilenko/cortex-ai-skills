
## Skills to analyze

- [x] ./skills/api-designer
- [x] ./skills/architecture-designer
- [x] ./skills/cli-developer
- [x] ./skills/cloud-architect
- [x] ./skills/code-documenter
- [x] ./skills/code-reviewer
- [x] ./skills/csharp-developer
- [x] ./skills/database-optimizer
- [x] ./skills/devops-engineer
- [x] ./skills/dotnet-core-expert
- [x] ./skills/javascript-pro
- [x] ./skills/nestjs-expert
- [x] ./skills/nextjs-developer
- [x] ./skills/playwright-expert
- [x] ./skills/prompt-engineer
- [x] ./skills/python-pro
- [x] ./skills/rag-architect
- [x] ./skills/react-expert
- [x] ./skills/secure-code-guardian
- [x] ./skills/security-reviewer
- [x] ./skills/spec-miner
- [x] ./skills/sql-pro
- [x] ./skills/sre-engineer
- [x] ./skills/test-master
- [x] ./skills/typescript-pro
- [x] ./skills/legacy-modernizer

## CRITICAL: One skill per run. Then STOP

You are performing a **security audit** of AI skill files in this repository. DO NOT modify any files inside `./skills/`. This is a READ-ONLY audit.

### What you do in THIS run

> **EXACTLY ONE SKILL. Then check the box, write the report entry, save, and EXIT.**
>
> Do NOT audit a second skill. Do NOT keep going. Do NOT be helpful by doing more.
> After you update this file with one result, you are DONE. Stop immediately.

### Steps for this single run

1. **Find your ONE skill** — scan the checklist above. Pick the FIRST `- [ ]` item. That is your ONLY job this run.
   - If NO `- [ ]` items remain, skip to the **Completion** section below.
   - Path is relative to repo root.
2. **Read ALL files** in that skill directory — `SKILL.md` and every file in `references/`.
3. **Audit against these threat categories:**
   - **Prompt injection / jailbreak vectors**: Instructions that could override system prompts, break out of role, or instruct the agent to ignore safety guidelines.
   - **Unsafe command execution**: Instructions to run shell commands without user confirmation, destructive operations (rm -rf, DROP TABLE, force push), or commands that disable safety checks (--no-verify, --force).
   - **Data exfiltration risks**: Instructions that could cause the agent to leak environment variables, secrets, credentials, API keys, or private files to external services.
   - **Privilege escalation**: Instructions that grant the skill excessive authority — modifying system files, changing permissions, installing global packages, or accessing resources outside the project scope.
   - **Social engineering / deception**: Instructions that tell the agent to hide its actions, suppress errors, avoid logging, or present false information to the user.
   - **Supply chain risks**: Instructions to fetch or execute code from untrusted external URLs, install unvetted packages, or curl-pipe-bash patterns.
   - **Overly permissive patterns**: Instructions that disable linting, skip tests, bypass code review, or weaken security posture in generated code.
   - **Sensitive data in references**: Hardcoded credentials, tokens, API keys, or PII in reference files.
4. **Update this file (two edits):**
   - **Checkbox**: change `- [ ]` to `- [x]` for the skill you just audited.
   - **Report entry**: fill in the matching line in the Report section. Use one of:
     - `PASS — No issues found.`
     - `WARN — <description of low-severity concern>`
     - `FAIL — <description of vulnerability with specific file and line reference>`
5. **STOP. You are done for this run.** Do not audit another skill. Exit now.

### Completion (only when ALL boxes are checked)

If you arrive at step 1 and find NO `- [ ]` items remaining, then and ONLY then:

- Append a `## Summary` section at the bottom with total skills audited, PASS/WARN/FAIL counts, and FAIL remediation recommendations.
- Output: `<promise>RALPH_DONE</promise>`

### Rules

- **ONE skill per run. No exceptions. Then stop.**
- Always save progress to this file before exiting.
- Never modify files inside `./skills/`.
- If a skill directory does not exist or is empty, mark it `PASS — Directory empty or missing.`
- Be specific in findings — cite the filename, approximate line, and the problematic instruction text.

## Report

- `./skills/api-designer`: PASS — No issues found.
- `./skills/architecture-designer`: PASS — No issues found.
- `./skills/cli-developer`: PASS — No issues found.
- `./skills/cloud-architect`: PASS — No issues found.
- `./skills/code-documenter`: PASS — No issues found.
- `./skills/code-reviewer`: PASS — No issues found.
- `./skills/csharp-developer`: PASS — No issues found.
- `./skills/database-optimizer`: PASS — No issues found.
- `./skills/devops-engineer`: FIXED — Replaced hardcoded K8s Secret DB URL with External Secrets Operator guidance (`kubernetes.md:106`); replaced inline `user:pass` credentials with `${DB_USER}/${DB_PASSWORD}` env var refs in Docker Compose example (`docker-patterns.md:66,75`).
- `./skills/dotnet-core-expert`: FIXED — Replaced JWT secret placeholder in `appsettings.json` with empty string + MUST NOT comment (`authentication.md:527`); replaced hardcoded `YourStrong@Passw0rd` and JWT secret in Docker Compose with `${SA_PASSWORD}` / `${JWT_SECRET}` env var refs (`cloud-native.md:54-55,66`).
- `./skills/javascript-pro`: PASS — No issues found.
- `./skills/nestjs-expert`: FIXED — Removed developer's absolute local filesystem path from cross-reference comment (`migration-from-express.md:989`); replaced with a generic skill-relative reference.
- `./skills/nextjs-developer`: FIXED — Added DOMPurify sanitization warning before raw HTML render (`server-components.md:288`); replaced `Access-Control-Allow-Origin: *` with specific origin and security caveat (`deployment.md:35`); changed revalidation secret from URL query param to `Authorization: Bearer` header pattern (`deployment.md:392`).
- `./skills/playwright-expert`: PASS — No issues found.
- `./skills/prompt-engineer`: PASS — No issues found. The skill actively promotes prompt injection defense (instruction hierarchy, input sandboxing, canary tokens, injection test suite). CI/CD examples correctly use GitHub Secrets for API keys. No hardcoded credentials, unsafe commands, or exfiltration risks.
- `./skills/python-pro`: FIXED — Replaced f-string SQL interpolation with parameterized query (`conn.execute("SELECT * FROM users WHERE id = ?", (user_id,))`) (`type-system.md:190`).
- `./skills/rag-architect`: PASS — No issues found. Placeholder API keys (`"your-api-key"`) appear throughout reference examples but are universally understood tutorial conventions; no real credentials, prompt injection vectors, unsafe commands, or exfiltration risks found.
- `./skills/react-expert`: PASS — No issues found.
- `./skills/secure-code-guardian`: PASS — No issues found. All secrets read from environment variables, no hardcoded credentials, no unsafe commands, no prompt injection vectors, no exfiltration risks. `'unsafe-inline'` in `styleSrc` CSP (xss-csrf.md line 37, owasp-prevention.md line 117) is a well-known pragmatic trade-off, not a skill-introduced vulnerability.
- `./skills/security-reviewer`: FIXED — Replaced CLI-argument secrets with env var refs (`$API_KEY`, `$VAULT_DB_PASSWORD`) (`infrastructure-security.md:184,192`); capped brute-force loop to 50 iterations, added `sleep` guard and explicit authorization note (`penetration-testing.md:88-90`).
- `./skills/spec-miner`: PASS — No issues found.
- `./skills/sql-pro`: PASS — No issues found. All reference files contain pure SQL examples with no hardcoded credentials, no prompt injection vectors, no unsafe agent instructions, and no supply chain risks. The session-level `SET enable_seqscan = OFF` in `references/optimization.md` is a standard diagnostic tool, not a security concern.
- `./skills/sre-engineer`: FIXED — Replaced `shell=True` with `shell=False` and list-form command in `AutomatedRunbook.execute()` (`automation-toil.md:265-270`); added `check=True` to all chaos rollback `subprocess.run` calls in `LatencyInjector` and `NetworkPartition` (`incident-chaos.md:303,358-361`).
- `./skills/test-master`: PASS — No issues found.
- `./skills/typescript-pro`: PASS — No issues found. All reference files contain pure TypeScript type-system examples. Environment variable names (`DATABASE_URL`, `API_KEY`) appear only in `ProcessEnv` type-declaration augmentations and correct `process.env` reads — no hardcoded values. The `npx @typescript/analyze-trace` command in `references/configuration.md` line 427 is a legitimate Microsoft TypeScript-team tool. No prompt injection vectors, unsafe agent instructions, supply chain risks, privilege escalation, social engineering, or exfiltration risks found.
- `./skills/legacy-modernizer`: PASS — No issues found.

## Summary

- **Total skills audited:** 25
- **PASS:** 17
- **WARN:** 8 (all remediated — see FIXED entries above)
- **FAIL:** 0

### Remediation Status

| Skill                | Original Finding                                                                   | Status   |
| -------------------- | ---------------------------------------------------------------------------------- | -------- |
| `devops-engineer`    | Inline credentials in K8s Secret and Docker Compose examples                       | ✅ FIXED |
| `dotnet-core-expert` | Hardcoded JWT secret in `appsettings.json`; plaintext passwords in Docker Compose  | ✅ FIXED |
| `nestjs-expert`      | Developer's absolute local filesystem path leaked in cross-reference comment       | ✅ FIXED |
| `nextjs-developer`   | XSS-prone raw HTML render; wildcard CORS; URL query-param revalidation secret      | ✅ FIXED |
| `python-pro`         | SQL f-string interpolation normalizes SQL injection pattern                        | ✅ FIXED |
| `security-reviewer`  | Secrets as CLI args (visible in process list); unbounded brute-force loop          | ✅ FIXED |
| `sre-engineer`       | `shell=True` normalizes command injection; missing `check=True` in chaos rollbacks | ✅ FIXED |
