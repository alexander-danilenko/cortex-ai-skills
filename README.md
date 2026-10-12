<p align="center">
  <img src="./assets/logo.svg" width="160" alt="Cortex AI Skills" />
</p>

<h1 align="center">Cortex — Contextual AI Coding Skills for Claude Code</h1>

<p align="center">
  <a href="https://github.com/alexander-danilenko/cortex-ai-skills/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT" />
  </a>
</p>

> 🚀 Install once and stop re-explaining how you write code. Claude picks the right conventions for whatever you've opened — TypeScript, Python, React, Next.js, NestJS, .NET, testing, docs.

## ✨ How It Works

No slash commands to memorize. Each skill describes when it should fire, and Claude Code pulls in whichever ones match what you're doing:

- Open a `.tsx` file → **react** and **typescript** kick in.
- Edit a NestJS controller → **nestjs** brings the module/DI/guard/DTO rules.
- Ask for tests → **testing** picks the right unit/integration/E2E approach.
- Draft API docs → **documentation** handles the voice and OpenAPI structure.
- Wrap up a ticket → **jira-report-comment** writes the Jira update from your commits.
- Hand a ticket to QA → **jira-qa-scope** writes the test scope and scenarios from the ticket and its commits.
- Solve a tricky bug → **learn-with-docs** captures the lesson in `docs/solutions/` so the next session doesn't rediscover it.

Install it once and your conventions follow you around. Nothing to paste at the start of a session, nothing to repeat on a fresh repo. (You can still call any skill yourself with `/cortex:<skill>` if you'd rather.)

## 📚 Skill Library

### Languages

- **`/cortex:typescript`** — Strict tsconfig, branded types, advanced generics, discriminated unions, tRPC, monorepos.
- **`/cortex:javascript`** — Modern ES2023+, Promise patterns, ESM/CJS, Web Workers, Node.js best practices.
- **`/cortex:python`** — Python 3.11+, type hints with mypy, async/await, pytest fixtures, dataclasses, Poetry.
- **`/cortex:csharp`** — C# 12, records, primary constructors, pattern matching, async, CQRS with MediatR.

### Frameworks

- **`/cortex:react`** — React 18/19, hooks, Server Components, Suspense, performance memoization, form actions.
- **`/cortex:nextjs`** — Next.js 14+ App Router, Server Actions, caching, Metadata API, Vercel deployment.
- **`/cortex:nestjs`** — Modules, DI, controllers/services, DTO validation, guards, JWT auth, TypeORM/Prisma.
- **`/cortex:dotnet-core`** — .NET 8 clean architecture, CQRS, minimal APIs, EF Core, AOT, cloud-native patterns.

### Engineering Workflows

- **`/cortex:testing`** — Unit, integration, E2E, performance, and security testing patterns plus coverage analysis.
- **`/cortex:documentation`** — Microsoft-style technical writing, JSDoc/Google/NumPy docstrings, OpenAPI, doc portals.
- **`/cortex:spec-mining`** — Reverse-engineer legacy or undocumented systems into EARS-format requirements.
- **`/cortex:legacy-modernization`** — Strangler fig, branch by abstraction, characterization tests, framework upgrades.
- **`/cortex:jira-report-comment`** — Turn git commits into a business-friendly Jira implementation report.
- **`/cortex:jira-qa-scope`** — Draft a QA scope and Given/When/Then scenarios from a Jira ticket and its commits.
- **`/cortex:coderabbit-resolve-feedback`** — Judge and fix CodeRabbit findings on a PR, then post approved replies.
- **`/cortex:learn-with-docs`** — Capture a solved problem as a grounded learning in `docs/solutions/`, with a `CONCEPTS.md` glossary.
- **`/cortex:learn-with-docs-refresh`** — Audit `docs/solutions/` against the code: update, merge, replace, or delete stale learnings.
- **`/cortex:humanize-text`** — Strip "AI fingerprints" from text so writing reads natural.
- **`/cortex:simple-english`** — ASD-STE100 Simplified Technical English for docs, runbooks, and error messages.

## 💡 Why Cortex

Most AI assistants will happily generate _something_. Getting them to write code _your_ way — your conventions, your architecture, your trade-offs — usually means re-explaining yourself every session or letting CLAUDE.md balloon out of control.

Cortex is what I built after I got tired of doing that. A stack of personal preferences, project scars, and team rules I've collected over the years, packaged so Claude can reach for the right one on its own. Fork it, gut half of it, swap mine for yours — that's kind of the point.

## 📦 Installation

Pick the path for your AI coding assistant:

### Claude Code Plugin

```bash
claude plugin marketplace add alexander-danilenko/cortex-ai-skills
claude plugin install cortex@alexander-danilenko
```

Done. Claude will pull in the right skills as you work and keep them updated.

<details>
<summary>Recommended companion Claude Code plugins</summary>

- [Official Claude Code plugins](https://claude.com/plugins):

  ```bash
  CLAUDE_PLUGINS=(
    "claude-code-setup"
    "claude-md-management"
    "code-review"
    "code-simplifier"
    "context7"
    "feature-dev"
    "skill-creator"
    "csharp-lsp"
    "rust-analyzer-lsp"
    "typescript-lsp"
  ) && for plugin in "${CLAUDE_PLUGINS[@]}"; do claude plugin install "${plugin}@claude-plugins-official"; done
  ```

- [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin)

- [obra/superpowers](https://github.com/obra/superpowers)

</details>

### Codex, Cursor, OpenCode, Pi, Gemini CLI, and other AI agents

Cortex installs into any agent that [`npx skills`](https://github.com/vercel-labs/skills) supports — Codex, Cursor, OpenCode, Pi, Gemini CLI, and more. Grab your `--agent` identifier from the [supported agents list](https://github.com/vercel-labs/skills#supported-agents).

Install all skills (swap `cursor` for your agent's identifier):

```bash
npx skills add alexander-danilenko/cortex-ai-skills --skill '*' --agent cursor
```

Install a single skill:

```bash
npx skills add alexander-danilenko/cortex-ai-skills --skill python --agent cursor
```

List available skills:

```bash
npx skills add alexander-danilenko/cortex-ai-skills --list
```

> To update, re-run the `add` command. Unlike the Claude Code plugin path, `npx skills` won't pull updates on its own.

## 🛠️ Development

To load the plugin from a local clone (session-only):

```bash
claude --plugin-dir /path/to/cloned/repo
```

To make it persistent, register the repo as a local marketplace in `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "local": {
      "source": {
        "source": "directory",
        "path": "/path/to/cloned/repo"
      }
    }
  }
}
```

Then install once:

```bash
claude plugin install cortex@local
```

After pulling new changes, update with:

```bash
claude plugin update cortex@local
```

## 🙏 Credits

[Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) inspired me to start this project.

## 🤝 Contributing

These skills reflect a personal workflow — fork freely and adapt them to yours.

When adding or updating skills, use the [`skill-creator` plugin](https://claude.com/plugins/skill-creator) so new skills match the expected format and conventions.

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
