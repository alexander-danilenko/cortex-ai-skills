# AGENTS.md Pro Workflows

## CREATE Workflow

Generate new AGENTS.md from scratch.

### 1. Detect Repository Structure

Scan for monorepo indicators:

- `lerna.json`, `pnpm-workspace.yaml`, `turbo.json`
- `workspaces` in `package.json`
- Multiple `package.json` files

Announce detection: "Detected [standard/monorepo] repository"

### 2. Analyze Codebase (Token-Conscious)

Read selectively, focusing on:

- `package.json` - Tech stack and scripts
- Config files - `.eslintrc`, `.prettierrc`, `tsconfig.json`
- `README.md` - Project purpose (1-2 sentences only)
- Key source files - Architecture patterns (sample 3-5 files max)
- Git hooks - Commit conventions

**Stop reading when core patterns are clear.** Avoid over-analysis.

### 3. Generate Condensed AGENTS.md

**Standard Repository:**

```markdown
# [Project] | [Tech Stack]

## COMMANDS
- Dev: `[command]`
- Build: `[command]`
- Test: `[command]`
- Lint: `[command] --fix`

## STRUCTURE
- `[dir]/` - [purpose]
- `[dir]/` - [purpose]

## PATTERNS
[1-2 key architectural patterns with minimal code examples]

## CODE STYLE
See `[config files]`
[Only project-specific rules NOT in configs]

## DOMAIN
[Only non-obvious project-specific terms]
| Term | Definition |
|------|------------|
| ... | ... |

## SECURITY
[Critical auth/validation patterns only]

## GIT
Format: `[convention]`
[Hooks if any]
```

**Monorepo Root:**

```markdown
# [Monorepo] | [Shared Stack]

## STRUCTURE
Projects:
- `/[project-a]` - [purpose]
- `/[project-b]` - [purpose]

## SHARED COMMANDS
- Install: `[command]`
- Build all: `[command]`
- Test all: `[command]`

## SHARED STANDARDS
See: `.eslintrc`, `.prettierrc` (root)

## PROJECT DOCS
See AGENTS.md in each project directory.
```

**Monorepo Sub-Project:**

```markdown
# [Project] | [Tech Stack]

## COMMANDS
[Project-specific commands]

## PATTERNS
[Project-specific patterns]

## SHARED STANDARDS
See root AGENTS.md

## DOMAIN
[Project-specific terms only]
```

### 4. Validate Output

Check:

- [ ] All sections actionable (no fluff)
- [ ] Line count ≤ 150 for standard projects
- [ ] Commands correct and tested
- [ ] No duplication of tool configs
- [ ] Security info present

### 5. Write Files

Write to appropriate locations. Announce: "Created AGENTS.md at [path]"

For monorepos, list all files created.

---

## OPTIMIZE Workflow

Condense existing AGENTS.md to reduce token count.

### 1. Read and Measure

Read current AGENTS.md. Estimate token count (chars ÷ 4).

### 2. Identify Bloat

Scan for anti-patterns (see [anti-patterns.md](anti-patterns.md)):

- Verbose headers
- Paragraph explanations
- Duplicated tool config
- Multiple similar examples
- Philosophical guidance
- Historical context

### 3. Apply Optimizations

Use patterns from [optimization-patterns.md](optimization-patterns.md):

- Compress headers: "## 1. Project Core Identity" → "## PROJECT"
- Tech stack to header: Move to title line
- Commands only: Remove explanations
- Reference configs: "See `.eslintrc`" instead of listing rules
- Single examples: One pattern per concept
- Imperative language: "Read files" not "You should read files"
- Lists over paragraphs: Always

### 4. Validate Quality

Run validation checks from [validation-rules.md](validation-rules.md):

- Token reduction ≥ 30%
- All critical info preserved
- No security information lost
- Model-agnostic language
- Commands verified

### 5. Report Results

Display:

- Original token estimate
- Optimized token estimate
- Reduction percentage
- Key improvements made

### 6. Write Optimized File

Overwrite original with optimized version.

---

## UPDATE Workflow

Sync existing AGENTS.md with codebase changes.

### 1. Read Current AGENTS.md

Load existing file to understand current state.

### 2. Detect Changes

Compare AGENTS.md against:

- `package.json` - New dependencies or scripts
- Config files - Updated linting/formatting rules
- Source structure - New directories or patterns
- Git hooks - Modified commit conventions

### 3. Identify Gaps

List what needs updating:

- Missing commands
- Outdated tech stack
- New architectural patterns
- Changed domain language
- Updated security patterns

### 4. Apply Updates

Update relevant sections while maintaining token efficiency.

### 5. Re-validate

Ensure updates maintain quality standards.

### 6. Write Updated File

Save changes. Report what was updated.

---

## VALIDATE Workflow

Check AGENTS.md quality and completeness.

### 1. Load Validation Rules

Reference [validation-rules.md](validation-rules.md) for criteria.

### 2. Run Checks

**Token Efficiency (40 pts):**

- Line count ≤ 150?
- No paragraphs > 3 lines?
- Headers concise?
- Configs referenced not duplicated?

**Completeness (30 pts):**

- Tech stack identified?
- Essential commands present?
- Security info included?
- Structure documented?

**Actionability (20 pts):**

- All sections concrete?
- Commands copy-pasteable?
- Patterns shown with code?
- No abstract guidance?

**Quality (10 pts):**

- Model-agnostic language?
- Consistent terminology?
- Well-organized?
- No redundancy?

### 3. Score and Grade

Calculate total score (0-100):

- 90-100: Excellent
- 70-89: Good
- 50-69: Fair
- <50: Needs improvement

### 4. Report Findings

List:

- Overall grade and score
- Issues found (by category)
- Specific recommendations
- Token efficiency metrics

### 5. Offer Optimization

If score < 90, ask: "Would you like me to optimize this AGENTS.md?"

---

## Output Standards

Every AGENTS.md must:

**Structure:**

- Tech stack in title/header
- Commands section first (most actionable)
- Patterns with code examples
- Security considerations
- Git conventions

**Format:**

- Concise headers (≤ 3 words)
- Bullets over paragraphs
- Code blocks for patterns
- Tables for glossary only
- Imperative language

**Content:**

- Reference configs, don't duplicate
- One example per pattern
- Project-specific info only
- Security-critical details
- Verified commands

**Constraints:**

- ≤ 150 lines for standard projects
- ≤ 100 lines for monorepo sub-projects
- ≤ 50 lines for monorepo root
- No paragraphs > 3 lines
- No redundant information

---

## Success Metrics

**Token Efficiency:**

- Standard project: ~500-800 tokens
- Monorepo root: ~300-400 tokens
- Sub-project: ~400-600 tokens

**Quality Indicators:**

- All commands verified
- Configs referenced, not duplicated
- Security info complete
- 100% actionable content
- No redundancy

**Completeness:**

- Tech stack clear
- Build/test/lint commands present
- Key patterns documented
- Domain language defined
- Git conventions specified
