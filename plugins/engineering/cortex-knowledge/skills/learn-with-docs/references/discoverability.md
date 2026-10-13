# Discoverability check

`docs/solutions/` only pays off when the next agent finds it. Run this check after every write.

1. **Find the target file.** Look for root instruction files: `AGENTS.md`, `CLAUDE.md`, or an equivalent (`GEMINI.md`, `.github/copilot-instructions.md`). When one only `@`-includes another, the included file holds the content and is the target. No instruction file at all → skip the check and say so in the report.
2. **Assess, don't string-match.** Would an agent reading the file learn three things?
   - A searchable store of documented solutions exists at `docs/solutions/`.
   - Enough structure to search it: category directories and frontmatter fields (`module`, `component`, `tags`, `problem_type`).
   - When it is relevant: implementing, debugging, or deciding in an area it covers.

   The spirit can be met by a line in an architecture tree, a gotchas bullet, or prose that never spells the path the same way. When it is met, stop.

3. **Draft the smallest addition** that teaches all three, in the file's own style. A line in an existing related section (a directory listing, docs section, conventions block) beats a new section. Add a section only when nothing in the file is close. Describe the store, not this skill — readers without the skill must still get value. Calibration, not a template:

   One line in a directory listing:

   ```text
   docs/solutions/   # documented solutions to past problems (bugs, patterns, conventions), one file per learning, grouped by category, YAML frontmatter: module, component, tags, problem_type
   ```

   A small section when nothing fits:

   ```markdown
   ## Documented solutions

   `docs/solutions/` holds documented solutions to past problems — bugs, patterns, conventions, decisions — one file per learning, grouped by category, with YAML frontmatter (`module`, `component`, `tags`, `problem_type`). Search it (grep the frontmatter, then read matches) when implementing, debugging, or deciding in an area it covers. `CONCEPTS.md` defines the project's domain terms.
   ```

   Keep the tone informational ("relevant when…", "search it when…"). An "always search before every task" directive causes redundant reads in workflows that already search.

4. **Act per mode.**
   - **Interactive** — show the proposed text and where it goes, explain in one line why it matters (fresh sessions and other tools will not know the store exists), and ask before editing. Use the host's question tool when it has one; otherwise ask in chat. Edit only on a yes. Only edit an existing instruction file — never create one.
   - **Non-interactive** — do not edit instruction files. Put the proposed text in the report as the discoverability recommendation.

5. **`CONCEPTS.md` variant.** When `CONCEPTS.md` exists, run the same check for it, same target file and same consent rule. Example line: `CONCEPTS.md   # shared domain vocabulary (entities, named processes, status concepts) — relevant when orienting or discussing domain concepts`. When `CONCEPTS.md` does not exist, skip this step silently.
