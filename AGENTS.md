# opencode-blog — Blog Creation & Optimization for OpenCode

## Project Overview

This repository contains **opencode-blog**, a blog content engine for
[OpenCode](https://opencode.ai). It ships:

- **1 primary agent** (`blog`) that orchestrates the full content lifecycle.
- **4 specialist subagents** (`blog-researcher`, `blog-writer`, `blog-seo`,
  `blog-reviewer`) invoked by the primary agent via the `task` tool.
- **22 sub-skills** loaded on demand through the `skill` tool.
- **12 content templates** and **14 reference files** bundled in
  `skills/blog/`.
- **1 slash command** (`/blog`) that routes to the primary agent.

Content is dual-optimized for Google rankings (December 2025 Core Update,
E-E-A-T) and AI citations (GEO/AEO).

## Repo Layout

```
opencode-blog/
  AGENTS.md                    # This file. Project instructions for opencode.
  opencode.json                # Project config (MCP, permissions, agent task perms).
  README.md                    # User-facing docs.
  agents/                      # Markdown agent definitions (installs to ~/.config/opencode/agents/).
    blog.md                    # Primary orchestrator agent (mode: primary).
    blog-researcher.md         # Subagent: statistics, sources, images, SERP.
    blog-writer.md             # Subagent: content generation.
    blog-seo.md                # Subagent: post-writing SEO validation.
    blog-reviewer.md           # Subagent: 100-point quality scoring.
  commands/                    # Slash commands (installs to ~/.config/opencode/commands/).
    blog.md                    # /blog <subcommand> entry point.
  skills/                      # SKILL.md definitions (installs to ~/.config/opencode/skills/<name>/SKILL.md).
    blog/                      # Knowledge skill: references + templates + analyzer.
      SKILL.md
      references/              # 14 on-demand knowledge files.
      templates/               # 12 content templates.
      scripts/                 # analyze_blog.py.
    blog-write/SKILL.md        # Workflow skills, one per subcommand.
    blog-rewrite/SKILL.md
    blog-analyze/SKILL.md
    blog-brief/SKILL.md
    blog-outline/SKILL.md
    blog-calendar/SKILL.md
    blog-strategy/SKILL.md
    blog-seo-check/SKILL.md
    blog-schema/SKILL.md
    blog-chart/SKILL.md
    blog-repurpose/SKILL.md
    blog-geo/SKILL.md
    blog-audit/SKILL.md
    blog-image/                # Gemini image generation (uses MCP).
    blog-cannibalization/SKILL.md
    blog-factcheck/SKILL.md
    blog-persona/SKILL.md
    blog-taxonomy/SKILL.md
    blog-notebooklm/           # NotebookLM source-grounded research.
    blog-audio/                # Gemini TTS narration.
    blog-google/               # Google API integration (PSI, CrUX, GSC, GA4...).
  scripts/analyze_blog.py      # Quality scorer (5-category, 100 points).
  install.sh / install.ps1     # Install everything to ~/.config/opencode/.
  uninstall.sh / uninstall.ps1
  tests/                       # pytest test suite.
```

## How OpenCode Loads This Project

1. **Skills** are auto-discovered from `~/.config/opencode/skills/<name>/SKILL.md`
   after install. The `skill` tool lists them, and any agent with `skill`
   permission can call `skill({ name: "blog-write" })` to load one.
2. **Agents** in `~/.config/opencode/agents/<name>.md` are auto-discovered:
   - `blog.md` is a **primary agent** (set via `mode: primary`). Cycle to it
     with `Tab` in the OpenCode TUI, or invoke with `@blog`.
   - The four specialists are **subagents** invoked by `blog` via the `task`
     tool, or directly by users via `@blog-writer`, etc.
3. **Commands** in `~/.config/opencode/commands/blog.md` produce `/blog
   <args>`, which sends the prompt to the `blog` primary agent.

## Commands

| Command | Purpose |
|---------|---------|
| `/blog write <topic>` | Write new article from scratch. |
| `/blog rewrite <file>` | Optimize an existing post. |
| `/blog analyze <file>` | 5-category 100-point scoring. |
| `/blog brief <topic>` | Detailed content brief. |
| `/blog outline <topic>` | SERP-informed outline. |
| `/blog calendar` | Editorial calendar. |
| `/blog strategy <niche>` | Blog positioning + topic clusters. |
| `/blog seo-check <file>` | On-page SEO validation. |
| `/blog schema <file>` | JSON-LD schema generation. |
| `/blog repurpose <file>` | Cross-platform repurposing. |
| `/blog geo <file>` | AI citation readiness audit. |
| `/blog image …` | AI image generation via Gemini MCP. |
| `/blog audit [dir]` | Full-site blog health assessment. |
| `/blog cannibalization` | Detect keyword overlap. |
| `/blog factcheck <file>` | Verify statistics. |
| `/blog persona …` | Manage writing personas. |
| `/blog taxonomy …` | CMS taxonomy management. |
| `/blog notebooklm <q>` | NotebookLM research. |
| `/blog audio …` | Gemini TTS narration. |
| `/blog google …` | PSI, CrUX, GSC, GA4, NLP, YouTube, Keywords. |

## Development Rules

- Keep `SKILL.md` files under 500 lines / 5000 tokens.
- `SKILL.md` frontmatter: only fields opencode recognizes (`name`,
  `description`, `license`, `compatibility`, `metadata`). Unknown fields are
  ignored.
- Agent frontmatter: use `mode` (`primary` | `subagent`), `description`
  (required), `tools` (lowercase: `read`, `write`, `edit`, `bash`, `grep`,
  `glob`, `webfetch`, `websearch`, `task`, `skill`, `todowrite`, …),
  `permission`, `temperature`, `model` as needed.
- Reference files should stay focused; aim under 200 lines for new ones.
- Scripts must have docstrings, a CLI interface, and JSON output where
  applicable.
- Follow kebab-case naming for all skill and agent directories.
- Subagents are invoked by primary agents via the `task` tool, never via
  `bash`.
- Python 3.11+ required; dependencies in `pyproject.toml`.
- Test with `python -m pytest tests/` after changes.

## Distribution

### Standalone install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/AgriciDaniel/opencode-blog/main/install.sh | bash
```

The installer copies skills, agents, and commands into the appropriate
`~/.config/opencode/` directories.

### Manual install

```bash
git clone https://github.com/AgriciDaniel/opencode-blog.git
cd opencode-blog
./install.sh
```

Restart OpenCode (or reload via `Ctrl+L` in the TUI) to pick up the new
skills, agents, and commands.
