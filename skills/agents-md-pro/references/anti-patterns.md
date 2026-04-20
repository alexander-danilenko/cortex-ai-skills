# AGENTS.md Anti-Patterns

Common mistakes that bloat token count and reduce effectiveness.

## 1. Verbose Headers

❌ **Anti-Pattern:**

```markdown
## 1. Project Core Identity and Technical Overview
## 2. Ubiquitous Domain Language and Glossary of Terms
## 3. Comprehensive Architectural Overview and Design Patterns
```

✅ **Pattern:**

```markdown
## PROJECT
## DOMAIN
## ARCHITECTURE
```

**Why:** Headers appear in every AGENTS.md file. Saving 5 tokens per header × 6 sections = 30 tokens saved.

---

## 2. Redundant Tech Stack Section

❌ **Anti-Pattern:**

```markdown
# Project Documentation

## Technology Stack
- Framework: Next.js 14
- Language: TypeScript
- Database: PostgreSQL
- ORM: Prisma
```

✅ **Pattern:**

```markdown
# Project | Next.js 14 | TypeScript | PostgreSQL | Prisma
```

**Why:** Tech stack in header saves 40+ tokens and provides immediate context.

---

## 3. Duplicating Tool Configuration

❌ **Anti-Pattern:**

```markdown
## Code Style
- Use 2 spaces for indentation (not tabs)
- Maximum line length of 100 characters
- Use single quotes for strings
- Always include semicolons
- Use trailing commas in multi-line objects
- Prefer const over let, never use var
```

✅ **Pattern:**

```markdown
## CODE STYLE
Enforced by `.eslintrc` + `.prettierrc`
```

**Why:** Linters already enforce these rules. No need to duplicate.

---

## 4. Explaining Commands Instead of Listing Them

❌ **Anti-Pattern:**

```markdown
## Testing
To run the test suite, execute the npm test command. This will run all
tests using Jest. You can also run tests in watch mode by using npm
run test:watch. For coverage reports, use npm run test:coverage.
```

✅ **Pattern:**

```markdown
## TEST
- Run: `npm test`
- Watch: `npm test:watch`
- Coverage: `npm test:coverage`
```

**Why:** Commands are self-documenting. Explanations add 60+ unnecessary tokens.

---

## 5. Philosophical Guidance

❌ **Anti-Pattern:**

```markdown
## Error Handling Philosophy
We believe in graceful degradation and user-friendly error messages.
When errors occur, consider the user experience and provide helpful
context about what went wrong and how to fix it.
```

✅ **Pattern:**

```markdown
## ERRORS
\`\`\`ts
catch (e) {
  logger.error(e);
  return { error: e.message };
}
\`\`\`
```

**Why:** AI needs concrete patterns, not philosophy. Show, don't tell.

---

## 6. Multiple Examples of Same Pattern

❌ **Anti-Pattern:**

```markdown
## API Routes

Example GET endpoint:
\`\`\`ts
export default async (req, res) => { /* ... */ }
\`\`\`

Example POST endpoint:
\`\`\`ts
export default async (req, res) => { /* ... */ }
\`\`\`

Example with authentication:
\`\`\`ts
export default async (req, res) => { /* ... */ }
\`\`\`
```

✅ **Pattern:**

```markdown
## API ROUTES
Location: `src/pages/api`
\`\`\`ts
export default async (req, res) => {
  // validate, process, respond
}
\`\`\`
```

**Why:** One clear example is enough. Multiple examples waste 100+ tokens.

---

## 7. Restating Standard Practices

❌ **Anti-Pattern:**

```markdown
## Git Workflow
- Create feature branches from main
- Use meaningful commit messages
- Keep commits atomic and focused
- Push to remote and create pull requests
- Request code review before merging
- Delete branches after merging
```

✅ **Pattern:**

```markdown
## GIT
Format: `type(scope): message`
Hooks: pre-commit (lint + test)
```

**Why:** Standard git practices don't need documentation. Only document project-specific conventions.

---

## 8. Historical Context

❌ **Anti-Pattern:**

```markdown
## Background
This project was started in 2020 as a monolith. In 2022 we migrated
to microservices. In 2023 we adopted TypeScript. The current architecture
reflects lessons learned from these transitions.
```

✅ **Pattern:**

```markdown
_Delete this section entirely_
```

**Why:** AI agents need current state only. History wastes tokens without providing actionable value.

---

## 9. Negative Examples (What NOT to Do)

❌ **Anti-Pattern:**

```markdown
## Component Patterns

❌ Don't do this:
\`\`\`ts
function BadComponent() { /* ... */ }
\`\`\`

✅ Do this instead:
\`\`\`ts
function GoodComponent() { /* ... */ }
\`\`\`
```

✅ **Pattern:**

```markdown
## COMPONENTS
\`\`\`ts
function Component() { /* ... */ }
\`\`\`
```

**Why:** Only show correct patterns. Bad examples double token cost with no benefit.

---

## 10. Verbose Introductions and Conclusions

❌ **Anti-Pattern:**

```markdown
# Welcome to the Project Documentation

This comprehensive guide will help you understand our codebase...

[sections...]

## Conclusion
Thank you for reading this documentation. If you have questions...
```

✅ **Pattern:**

```markdown
# Project | Tech Stack

[sections only]
```

**Why:** AI doesn't need greetings or conclusions. Get straight to content.

---

## 11. Explaining the Obvious

❌ **Anti-Pattern:**

```markdown
## Directory Structure
The `src/` directory contains all source code files. The `tests/`
directory contains test files. The `public/` directory contains
static assets that will be publicly accessible.
```

✅ **Pattern:**

```markdown
## STRUCTURE
- `src/components/` - React components
- `src/utils/` - Utilities
```

**Why:** Only document non-obvious directories. Standard directories are self-explanatory.

---

## 12. Nested Lists Without Value

❌ **Anti-Pattern:**

```markdown
## Features
- User Management
  - Registration
    - Email validation
    - Password requirements
  - Login
    - Session management
    - Remember me
```

✅ **Pattern:**

```markdown
## FEATURES
Auth: `src/auth/` (registration, login, sessions)
```

**Why:** Nested lists consume tokens. Group related items with location reference.

---

## 13. Repeating Package.json Scripts

❌ **Anti-Pattern:**

```markdown
## Available Scripts
- `npm run dev` - Starts development server
- `npm run build` - Builds for production
- `npm run start` - Starts production server
- `npm test` - Runs test suite
- `npm run lint` - Lints code
- `npm run format` - Formats code
```

✅ **Pattern:**

```markdown
## COMMANDS
Dev: `npm run dev`
Build: `npm run build`
Test: `npm test`
Lint: `npm run lint --fix`
```

**Why:** Only list essential commands. Users can check package.json for full list.

---

## 14. Abstract Architecture Descriptions

❌ **Anti-Pattern:**

```markdown
## Architecture
We follow clean architecture principles with clear separation of
concerns. The presentation layer communicates with the business logic
layer through well-defined interfaces. Data access is abstracted...
```

✅ **Pattern:**

```markdown
## ARCHITECTURE
- `src/ui/` - Components
- `src/domain/` - Business logic
- `src/data/` - DB/API access
```

**Why:** Show structure, not philosophy. Directories reveal architecture.

---

## 15. Exhaustive Domain Glossary

❌ **Anti-Pattern:**

```markdown
## Domain Glossary
| Term | Definition |
|------|------------|
| User | A person who interacts with the system |
| Session | A period of user activity |
| Token | Authentication credential |
| Role | User permission level |
| Admin | User with elevated privileges |
[20+ more obvious terms...]
```

✅ **Pattern:**

```markdown
## DOMAIN
| Term | Definition |
|------|------------|
| Merchant | Seller with inventory system access |
| Settlement | Daily payout to merchant account |
```

**Why:** Only define project-specific or non-obvious terms.

---

## Token Impact Examples

| Anti-Pattern                  | Tokens | Pattern           | Tokens | Saved |
| ----------------------------- | ------ | ----------------- | ------ | ----- |
| "## 1. Project Core Identity" | 8      | "## PROJECT"      | 3      | 63%   |
| Explaining `npm test`         | 45     | "`npm test`"      | 4      | 91%   |
| Duplicating .eslintrc         | 89     | "See `.eslintrc`" | 4      | 96%   |
| Philosophy paragraph          | 67     | Code example      | 15     | 78%   |
| Three similar examples        | 156    | One example       | 52     | 67%   |

### Average savings per anti-pattern removed: 79%

## Detection Checklist

Scan AGENTS.md for these red flags:

- [ ] Paragraphs longer than 3 lines
- [ ] Sections without commands or code examples
- [ ] Duplicate information from tool configs
- [ ] Multiple examples showing the same pattern
- [ ] Explanations of how to use standard commands
- [ ] Historical background or evolution
- [ ] Philosophical statements about code quality
- [ ] Nested lists more than 2 levels deep
- [ ] Greeting/conclusion sections
- [ ] Obvious terms in glossary (user, session, etc.)
- [ ] Directory descriptions without project specifics
- [ ] Multiple paragraphs explaining what could be a list
