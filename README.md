<p align="center">
  <img src="./assets/logo.svg" width="160" alt="AI Skills — robot" />
</p>

<h1 align="center">✨ AI Skills Collection</h1>

<p align="center">
  <a href="https://github.com/alexander-danilenko/cortex-ai-skills/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT" />
  </a>
</p>

> 🚀 Personal skills library for AI coding assistants (Claude Code, Cursor, Codex, OpenCode, GitHub Copilot)

## 📦 Installation

### As a Claude Code Plugin

```bash
claude plugin marketplace add alexander-danilenko/cortex-ai-skills
claude plugin install cortex@alexander-danilenko
```

Skills become available as `/<skill-name>`, e.g. `/api-designer`.

### Via `npx skills`

Install all skills:

```bash
npx skills add alexander-danilenko/cortex-ai-skills --skill '*' --agent claude-code --global --copy
```

Install a single skill:

```bash
npx skills add alexander-danilenko/cortex-ai-skills --skill agents-md-pro
```

To view the list of available skills, run:

```bash
npx skills add alexander-danilenko/cortex-ai-skills --list
```

## 🌟 Contrib Skills

Skills from other repos I use daily:

```bash
npx skills add anthropics/skills --skill skill-creator --agent claude-code --global --copy
```

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

These are personal skills for my workflow. Feel free to fork and adapt for your own use.

When adding or updating skills, use [Anthropic's skill-creator skill](https://github.com/anthropics/skills/tree/main/skills/skill-creator) so new skills match the expected format and conventions.

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
