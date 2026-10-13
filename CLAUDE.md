# CLAUDE.md

Guidance for AI coding agents working in this repository.

## Project

**cortex** — a Claude Code plugin marketplace (`alexander-danilenko-cortex`) of domain plugins providing AI coding skills. Pure markdown + YAML, no build system. Marketplace manifest: `.claude-plugin/marketplace.json`; each plugin has its own `plugins/<group>/<plugin>/.claude-plugin/plugin.json`. Skills invoke as `/<plugin>:<skill-name>`.

## Skill Structure

```text
plugins/<group>/<plugin>/
├── .claude-plugin/plugin.json   # plugin manifest (own semver, dependencies)
└── skills/<skill-name>/
    ├── SKILL.md                 # skill definition + YAML frontmatter
    ├── references/              # optional, loaded conditionally by SKILL.md
    ├── assets/                  # optional, templates and schemas
    └── scripts/                 # optional, helpers invoked by SKILL.md
```

A plugin is installed from a cache copy of its own directory, so a skill must never reference files outside its plugin. Plugins sit in a group directory, `plugins/common/` or `plugins/engineering/`; the group is also the `category` field in `marketplace.json`, and a plugin's `source` there is `./plugins/<group>/<plugin>`. Cross-plugin needs go in `dependencies`.

## Skill Authoring — `/skill-creator` Required

Creating, editing, condensing, or auditing any `SKILL.md` or its `references/` **requires the [`skill-creator` plugin](https://claude.com/plugins/skill-creator)**. It is the single source of truth for frontmatter fields, body-section order, progressive-disclosure conventions, reference-file layout, and token efficiency — this repo intentionally does not duplicate those rules.

Install it once:

```bash
claude plugin install skill-creator@claude-plugins-official
```

Then invoke `/skill-creator:skill-creator` for any skill-authoring task.

**If `/skill-creator:skill-creator` is not installed, stop and ask the user to install it before running the prompt.** Do not fall back to hand-authoring a skill from memory or from this file — the conventions drift quickly and the plugin is the authority.

## Git

- **Never commit unless explicitly asked.** Stage, show the diff, wait for confirmation. Do not commit proactively or per atomic change: every commit triggers a plugin version bump, so a commit is one meaningful, finished feature.
- **Conventional Commits**: `<type>(<scope>): <description>`
  - Types: `feat`, `fix`, `docs`, `refactor`, `chore`
  - Scope: skill name, or the plugin name for plugin-wide changes, or `marketplace` for repo-wide changes
- No triple backticks in commit messages.

## Versioning

**Bump as part of the change, not after.** A `PreToolUse` hook (`.claude/hooks/check-plugin-versions.sh`) blocks `git commit` unless every touched plugin has exactly one patch/minor/major step over `HEAD` staged. You pick the level from the plugin's diff; the hook only enforces it.

Classify the change (patch / minor / major), then update the `plugin.json` of every plugin touched (`plugins/<group>/<plugin>/.claude-plugin/plugin.json`) in the same diff. A commit without a matching bump is incomplete.

Bump each touched plugin's `plugin.json` to the highest level present in that plugin's part of the diff:

- **patch**: typos, wording, formatting, config adjustments
- **minor**: expanded skill content, new references, new/removed skill
- **major**: rewritten role/workflow, breaking structural change

Mixed changes take the highest level (2 patches + 1 minor = minor).

### Review (every review task)

Every review — code review, audit, PR, self-check — must verify the version bump:

1. Determine the actual semver level of the diff.
2. Compare against the bump in each touched plugin's `plugin.json`.
3. **Missing or under-bumped**: fix in the same pass; note the change and reason to the user.
4. **Over-bumped**: flag with a suggested downgrade; don't silently edit (may be intentional).

## Markdown Formatting

A `PostToolUse` hook (`.claude/hooks/lint-fix-markdown.sh`) runs `prettier --write` and `markdownlint-cli2 --fix` on every markdown file you edit, then validates it; fix whatever it reports. To check everything manually: `npx -y prettier --check "**/*.md" && npx -y markdownlint-cli2 "**/*.md"`. Configs: `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`.

Add a markdownlint disable only when the rule is genuinely wrong for this codebase, with a comment explaining why.

## Conventions

- **Naming**: kebab-case for skill directories and files.
- **Formatting**: UTF-8, LF, 2-space indent — see `.editorconfig`.
- **Reference files**: conditionally loaded by SKILL.md — never standalone skills.
- **Frontmatter**: `name` and `description`, plus `argument-hint` on a skill that takes a mode or target argument. Nothing else — in particular, no `allowed-tools`.

  `allowed-tools` is not a capability declaration — it pre-approves tools so they run **without a permission prompt** for the turn that invokes the skill. Adding it means these skills silently bypass the consumer's own permission settings, which is not ours to decide for someone installing a plugin. Leaving it out means every tool call goes through their configured permissions. (The field that actually restricts is `disallowed-tools`, which removes tools from the pool while a skill is active — only justified for a skill that must never call something, and none of ours qualify.)
