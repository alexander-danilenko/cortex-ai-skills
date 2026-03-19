# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**cortex** — a Claude Code plugin providing a library of AI coding skills. Pure markdown + YAML, no build system.

Plugin name: `cortex` (defined in `.claude-plugin/plugin.json`). Skills are invoked as `/cortex:<skill-name>`.

## Skill Structure

Each skill lives in `skills/<skill-name>/` with this layout:

```
skills/<skill-name>/
├── SKILL.md           # Required — skill definition with YAML frontmatter
├── metadata.yml       # Authorship, domain, triggers, related skills
└── references/        # Optional — supporting docs loaded conditionally
```

### SKILL.md Frontmatter

Only these fields are recognized by Claude Code:

```yaml
---
name: skill-name                    # kebab-case, matches directory name
description: When to invoke this skill
allowed-tools: Read, Grep, Glob     # Optional — restricts available tools
user-invocable: true                # Optional — shows in /slash menu
---
```

### SKILL.md Content Sections (in order)

1. **H1 Title** — human-friendly name
2. **Role Definition** — expertise level and domain
3. **When to Use This Skill** — bulleted invocation scenarios
4. **Core Workflow** — 3-5 numbered execution steps
5. **Reference Guide** — table mapping topics to `references/*.md` files with load conditions
6. **Constraints** — MUST DO / MUST NOT DO lists
7. **Output Templates** — what the skill produces
8. **Knowledge Reference** — comma-separated concepts/frameworks

### metadata.yml

Validated by `schemas/metadata.schema.json`. Required fields: `authors`, `license`, `version`. Optional fields: `domain`, `triggers`, `role`, `scope`, `output-format`, `related-skills`. See the schema for allowed values and formats.

## Git

- **Never commit unless explicitly asked.** Stage and show the diff, then wait for confirmation.
- **Conventional Commits** format: `<type>(<scope>): <description>`
  - Types: `feat`, `fix`, `docs`, `refactor`, `chore`
  - Scope: skill name when applicable, e.g. `feat(api-designer): add rate limiting reference`
  - Plugin-wide changes: `chore(plugin): bump plugin version`

## Versioning

### Skill versions (`metadata.yml`)

When a skill is updated, bump `version` in its `metadata.yml` following semver:

- **patch** (1.0.0 → 1.0.1): typo fixes, wording tweaks, formatting changes
- **minor** (1.0.0 → 1.1.0): new reference files, new sections, expanded guidance
- **major** (1.0.0 → 2.0.0): rewritten role/workflow, changed scope or output format, breaking changes to skill behavior

### Plugin version (`plugin.json`)

The plugin version tracks the overall collection state, bumped independently from individual skills:

- **patch**: any skill version bump (regardless of skill bump type)
- **minor**: new skill added, skill removed, or schema changes
- **major**: breaking structural changes (plugin format, directory layout)

Any skill version bump **must** also bump the plugin patch version.

## Conventions

- **Naming**: kebab-case for skill directories and file names
- **Formatting**: UTF-8, LF line endings, 2-space indent (see `.editorconfig`)
- **Skill creation**: Use [Anthropic's `/skill-creator` skill](https://github.com/anthropics/skills/tree/main/skills/skill-creator) to match expected format and make the skill token efficient
- **Reference files**: Loaded conditionally by SKILL.md — never standalone skills
- **allowed-tools in frontmatter**: Read-only skills get `Read, Grep, Glob`; editing skills add `Write, Edit`; automation skills add `Bash`
- **related-skills sync**: The `related-skills` enum in `schemas/metadata.schema.json` must list every skill directory name. Adding or removing a skill requires updating this enum.
