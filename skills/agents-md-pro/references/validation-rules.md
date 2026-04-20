# AGENTS.md Validation Rules

## Critical Quality Checks

### 1. Token Efficiency

- [ ] Total line count ≤ 150 for standard projects
- [ ] No paragraph longer than 3 lines
- [ ] No redundant explanations of standard practices
- [ ] Commands reference configs instead of duplicating rules
- [ ] Headers are concise (≤ 3 words where possible)

### 2. Completeness

- [ ] Project name and tech stack in header
- [ ] All essential build/test/lint commands present
- [ ] Security-critical information preserved
- [ ] Git/commit conventions specified
- [ ] File structure or key directories mapped

### 3. Actionability

- [ ] Every section contains concrete commands or rules
- [ ] No philosophical explanations or "why" discussions
- [ ] Patterns shown with code examples, not prose
- [ ] All commands are copy-pasteable and correct
- [ ] No abstract guidance without specific actions

### 4. Model-Agnostic Language

- [ ] No references to specific AI models (GPT, Claude, etc.)
- [ ] Universal terminology (avoid brand-specific jargon)
- [ ] Clear, unambiguous instructions
- [ ] No assumptions about AI capabilities
- [ ] Focus on observable behaviors, not AI understanding

### 5. Structure & Organization

- [ ] Logical section order (identity → commands → patterns → rules)
- [ ] No duplicate information across sections
- [ ] Related information grouped together
- [ ] Clear section headers that indicate content
- [ ] Monorepo structure properly documented

### 6. Security

- [ ] Authentication/authorization patterns documented
- [ ] Input validation requirements specified
- [ ] Secret management approach clear
- [ ] Security-critical commands/patterns highlighted
- [ ] No security information removed during condensing

### 7. Tool Integration

- [ ] Linter configs referenced, not duplicated
- [ ] Formatter configs referenced, not duplicated
- [ ] Test framework mentioned with run commands
- [ ] CI/CD tools identified with relevant commands
- [ ] Package manager clearly specified

### 8. Domain Language

- [ ] Project-specific terms defined (if any)
- [ ] No jargon without context
- [ ] Acronyms explained on first use
- [ ] Consistent terminology throughout
- [ ] Domain concepts mapped to code locations

## Validation Workflow

### Phase 1: Automated Checks

1. Count total lines (target: ≤ 150)
2. Identify paragraphs > 3 lines
3. Check for required sections
4. Verify all code blocks have language tags
5. Count token usage (estimate)

### Phase 2: Content Analysis

1. Verify commands are present and correct
2. Check for tool config duplication
3. Identify redundant explanations
4. Ensure security info is complete
5. Validate model-agnostic language

### Phase 3: Quality Assessment

1. Score token efficiency (tokens saved vs original)
2. Rate completeness (all critical info present?)
3. Measure actionability (concrete vs abstract ratio)
4. Check consistency (terminology, formatting)
5. Verify monorepo structure (if applicable)

## Scoring System

### Token Efficiency (40 points)

- Excellent (40): ≥50% reduction from verbose version
- Good (30): 30-49% reduction
- Fair (20): 10-29% reduction
- Poor (0): <10% reduction

### Completeness (30 points)

- Excellent (30): All critical sections present and populated
- Good (20): Minor gaps in non-critical areas
- Fair (10): Missing some important information
- Poor (0): Missing critical sections

### Actionability (20 points)

- Excellent (20): 100% concrete, actionable content
- Good (15): >80% actionable, minimal fluff
- Fair (10): 50-80% actionable
- Poor (0): <50% actionable, mostly abstract

### Quality (10 points)

- Excellent (10): Model-agnostic, consistent, well-organized
- Good (7): Minor inconsistencies
- Fair (4): Multiple quality issues
- Poor (0): Significant quality problems

**Overall Grade:**

- 90-100: Excellent
- 70-89: Good
- 50-69: Fair
- <50: Needs improvement

## Common Validation Failures

### ❌ Token Bloat

```markdown
## Testing Strategy
Our project uses Jest as the testing framework. To run tests, you should
execute the npm test command. We aim for high test coverage and follow
TDD principles when possible.
```

### ✅ Token Efficient

```markdown
## TEST
`npm test` (Jest)
```

---

### ❌ Redundant with Tool Configs

```markdown
## Code Style
- 2 spaces indentation
- 100 char line limit
- Single quotes
- Semicolons required
```

### ✅ References Config

```markdown
## CODE STYLE
See `.eslintrc` + `.prettierrc`
```

---

### ❌ Abstract Guidance

```markdown
## Error Handling
Errors should be handled gracefully. Consider the user experience and
provide helpful error messages.
```

### ✅ Concrete Pattern

```markdown
## ERRORS
Pattern:
\`\`\`ts
try { /* ... */ }
catch (e) {
  logger.error(e);
  return { error: e.message };
}
\`\`\`
```

---

### ❌ Missing Security Info

```markdown
## API Routes
Located in `src/api/`. Return JSON responses.
```

### ✅ Includes Security

```markdown
## API ROUTES
Location: `src/api/`
Auth: JWT via `auth.middleware.ts`
Validate: Zod schemas in `schemas/`
```

## Monorepo-Specific Validation

### Root AGENTS.md

- [ ] Lists all sub-projects
- [ ] Documents shared tooling only
- [ ] References sub-project files
- [ ] No duplication of sub-project details

### Sub-Project AGENTS.md

- [ ] References root for shared standards
- [ ] Contains only project-specific info
- [ ] No duplication of root-level details
- [ ] Clear project identity
