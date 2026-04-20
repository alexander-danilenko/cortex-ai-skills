# Token Optimization Patterns

## Core Principles

1. **Every word must justify its token cost**
2. **Reference existing configs instead of duplicating**
3. **Commands over explanations**
4. **Bullets over paragraphs**

## Reduction Techniques

### 1. Header Compression

**Before (13 tokens):**

```markdown
## 1. Project Core Identity and Overview
```

**After (5 tokens):**

```markdown
## PROJECT
```

### 2. Eliminate Redundant Explanations

**Before (45 tokens):**

```markdown
## Code Style
We follow strict TypeScript conventions. All code must be properly typed.
Use ESLint and Prettier for formatting. Run `npm run lint` to check your code.
```

**After (12 tokens):**

```markdown
## CODE STYLE
- Lint: `npm run lint --fix`
- Config: `.eslintrc`, `.prettierrc`
```

### 3. Reference Tool Configs

**Before (89 tokens):**

```markdown
## Coding Standards
- Use 2 spaces for indentation
- Maximum line length of 100 characters
- Use single quotes for strings
- Always use semicolons
- Use trailing commas in multi-line objects
- Prefer const over let
```

**After (11 tokens):**

```markdown
## CODE STYLE
See `.eslintrc` and `.prettierrc`
```

### 4. Consolidate Sections

**Before (65 tokens):**

```markdown
## Build Process
Run `npm run build` to build the project.

## Testing
Run `npm test` to run tests.

## Linting
Run `npm run lint` to check code quality.
```

**After (18 tokens):**

```markdown
## COMMANDS
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint --fix`
```

### 5. Imperative Language

**Before (22 tokens):**

```markdown
When you need to modify files, you should always read them first.
```

**After (5 tokens):**

```markdown
Read files before editing.
```

### 6. Tech Stack in Header

**Before (35 tokens):**

```markdown
# Project Documentation

## Technology Stack
- Framework: Next.js 14
- Language: TypeScript
- Database: PostgreSQL
```

**After (12 tokens):**

```markdown
# Project | Next.js 14 | TypeScript | PostgreSQL
```

### 7. Table to List (when appropriate)

**Before (structured but verbose):**

```markdown
| Command | Purpose | When to Use |
|---------|---------|-------------|
| npm run dev | Start development server | During local development |
| npm run build | Create production build | Before deployment |
```

**After (more concise for simple info):**

```markdown
- Dev: `npm run dev`
- Build: `npm run build`
```

### 8. Remove Redundant Context

**Before (45 tokens):**

```markdown
## Directory Structure
The `src/` directory contains all source code. The `src/components/` directory
contains React components. The `src/utils/` directory contains utility functions.
```

**After (15 tokens):**

```markdown
## STRUCTURE
- `src/components/` - React components
- `src/utils/` - Utilities
```

### 9. Pattern Examples (Show, Don't Explain)

**Before (78 tokens):**

```markdown
## API Routes
All API routes should be created in the `src/pages/api` directory. They should
export a default async function that receives request and response objects. Always
validate input data and handle errors appropriately with try-catch blocks.
```

**After (32 tokens):**

```markdown
## API ROUTES
Location: `src/pages/api`

Pattern:
\`\`\`ts
export default async (req, res) => {
  // validate, process, respond
}
\`\`\`
```

### 10. Distill to Actionable Rules Only

**Before (55 tokens):**

```markdown
## Git Workflow
We use conventional commits for our commit messages. This helps us maintain
a clean git history and makes it easier to generate changelogs. Please follow
this format when creating commits.
```

**After (8 tokens):**

```markdown
## GIT
Format: `type(scope): message`
```

## Anti-Patterns to Avoid

1. **Philosophical explanations** - Focus on "what" and "how", not "why"
2. **Examples of what NOT to do** - Only show correct patterns
3. **Multiple examples of the same pattern** - One clear example is enough
4. **Restating tool documentation** - Just reference the tool
5. **Historical context** - Focus on current state only
6. **Verbose greetings/conclusions** - Get straight to the point

## Target Metrics

- **Minimum reduction**: 30% from verbose version
- **Ideal reduction**: 50-70% while preserving all critical info
- **Maximum line count**: ~100 lines for standard projects
