# CLAUDE.md

Guidance for AI coding agents working in this repository.

## Project

**cortex** — a Claude Code plugin providing AI coding skills. Pure markdown + YAML, no build system. Plugin manifest: `.claude-plugin/plugin.json`. Skills invoke as `/cortex:<skill-name>`.

## Skill Structure

```text
skills/<skill-name>/
├── SKILL.md        # skill definition + YAML frontmatter
└── references/     # optional, loaded conditionally by SKILL.md
```

## Skill Authoring — `/skill-creator` Required

Creating, editing, condensing, or auditing any `SKILL.md` or its `references/` **requires the `/skill-creator` plugin** ([anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/skill-creator)). It is the single source of truth for frontmatter fields, body-section order, progressive-disclosure conventions, reference-file layout, and token efficiency — this repo intentionally does not duplicate those rules.

Install it once:

```bash
claude plugin marketplace add anthropics/skills
claude plugin install skill-creator@anthropics
```

Then invoke `/skill-creator:skill-creator` for any skill-authoring task.

**If `/skill-creator:skill-creator` is not installed, stop and ask the user to install it before running the prompt.** Do not fall back to hand-authoring a skill from memory or from this file — the conventions drift quickly and the plugin is the authority.

## Git

- **Never commit unless explicitly asked.** Stage, show the diff, wait for confirmation.
- **Conventional Commits**: `<type>(<scope>): <description>`
  - Types: `feat`, `fix`, `docs`, `refactor`, `chore`
  - Scope: skill name, or `plugin` for plugin-wide changes
- No triple backticks in commit messages.

## Versioning

**Bump as part of the change, not after.** Classify the change (patch / minor / major), then update `.claude-plugin/plugin.json` in the same diff. A commit without a matching bump is incomplete.

Bump `plugin.json` to the highest level present in the diff:

- **patch**: typos, wording, formatting, config adjustments
- **minor**: expanded skill content, new references, new/removed skill
- **major**: rewritten role/workflow, breaking structural change

Mixed changes take the highest level (2 patches + 1 minor = minor).

### Review (every review task)

Every review — code review, audit, PR, self-check — must verify the version bump:

1. Determine the actual semver level of the diff.
2. Compare against the bump in `plugin.json`.
3. **Missing or under-bumped**: fix in the same pass; note the change and reason to the user.
4. **Over-bumped**: flag with a suggested downgrade; don't silently edit (may be intentional).

## Markdown Formatting

Run `./lint.sh` until it exits clean before completing any markdown task — see the script header for usage. Configs: `.prettierrc`, `.prettierignore`, `.markdownlint.json`.

Add a markdownlint disable only when the rule is genuinely wrong for this codebase, with a comment explaining why.

## Conventions

- **Naming**: kebab-case for skill directories and files.
- **Formatting**: UTF-8, LF, 2-space indent — see `.editorconfig`.
- **Reference files**: conditionally loaded by SKILL.md — never standalone skills.
- **allowed-tools**: read-only → `Read, Grep, Glob`; editing → add `Write, Edit`; automation → add `Bash`.
