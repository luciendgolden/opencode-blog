# opencode-blog — AI Blog Creation for OpenCode

[![CI](https://github.com/AgriciDaniel/opencode-blog/actions/workflows/ci.yml/badge.svg)](https://github.com/AgriciDaniel/opencode-blog/actions/workflows/ci.yml)
[![GitHub release](https://img.shields.io/github/v/release/AgriciDaniel/opencode-blog)](https://github.com/AgriciDaniel/opencode-blog/releases/latest)
![OpenCode Skill Pack](https://img.shields.io/badge/OpenCode-Skill_Pack-blueviolet)
![License: MIT](https://img.shields.io/badge/License-MIT-green)
![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-blue)
![Sub-Skills](https://img.shields.io/badge/Sub--Skills-22-orange)

> **Blog:** [See how opencode-blog works](https://agricidaniel.com/blog/opencode-blog-writer)

`opencode-blog` is a blog content engine for [OpenCode](https://opencode.ai)
that creates, optimizes, and manages content at scale. It generates complete
articles, briefs, calendars, and schemas — dual-optimized for Google rankings
and AI citation platforms (ChatGPT, Perplexity, AI Overviews).

It ships as a self-contained pack of OpenCode primitives:

- **1 primary agent** (`blog`) — the orchestrator you talk to.
- **4 specialist subagents** — researcher, writer, SEO, reviewer.
- **22 on-demand skills** — one per `/blog <subcommand>` workflow.
- **1 slash command** (`/blog`) — entry point that routes into the orchestrator.
- **12 content templates** + **14 reference files** + a Python quality scorer.

## Table of Contents

- [Demo](#demo)
- [Quick Start](#quick-start)
- [How It Works](#how-it-works)
- [Commands](#commands)
- [Features](#features)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Uninstall](#uninstall)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Demo

[Watch the Demo on YouTube](https://www.youtube.com/watch?v=AeLC4iutG8w)

---

## Quick Start

**One-command install (Unix/macOS):**

```bash
curl -fsSL https://raw.githubusercontent.com/AgriciDaniel/opencode-blog/main/install.sh | bash
```

**Or clone and install manually:**

```bash
git clone https://github.com/AgriciDaniel/opencode-blog.git
cd opencode-blog
chmod +x install.sh && ./install.sh
```

**Windows (PowerShell):**

```powershell
.\install.ps1
```

The installer copies everything into the OpenCode global config directory:

```
~/.config/opencode/
  skills/blog/                   # Knowledge skill (refs + templates + analyzer)
  skills/blog-write/SKILL.md     # …and 20 more sub-skills
  agents/blog.md                 # Primary orchestrator agent
  agents/blog-{researcher,writer,seo,reviewer}.md   # Subagents
  commands/blog.md               # /blog slash command
```

Restart OpenCode (or reload the TUI) after installing.

## How It Works

```
                    ┌──────────────────────────────────────────┐
   /blog write …  ─►│  blog (primary agent, ~/.config/opencode)│
                    └────┬─────────────────────────────────────┘
                         │   loads on demand
                         ▼
                    ┌──────────────────────┐
                    │  skill: blog-write   │
                    │  skill: blog-rewrite │
                    │  skill: blog-analyze │
                    │  …21 more            │
                    └────┬─────────────────┘
                         │   delegates via task tool
                         ▼
                    ┌──────────────────────┐
                    │  blog-researcher     │  Stats, sources, images, SERP
                    │  blog-writer         │  Drafts the article
                    │  blog-seo            │  On-page SEO validation
                    │  blog-reviewer       │  100-point quality scoring
                    └──────────────────────┘
```

The `blog` primary agent is the orchestrator: it parses the sub-command,
loads the relevant skill via the `skill` tool, and delegates work to
specialist subagents via the `task` tool. Sub-skills bundle workflow steps;
references and templates are loaded with the `read` tool only when needed.

## Commands

| Command | Description |
|---------|-------------|
| `/blog write <topic>` | Write a new blog post from scratch. |
| `/blog rewrite <file>` | Optimize an existing blog post. |
| `/blog analyze <file>` | Quality audit with 0-100 score. |
| `/blog brief <topic>` | Detailed content brief. |
| `/blog calendar` | Editorial calendar. |
| `/blog strategy <niche>` | Blog strategy and topic ideation. |
| `/blog outline <topic>` | SERP-informed content outline. |
| `/blog seo-check <file>` | Post-writing SEO validation. |
| `/blog schema <file>` | JSON-LD schema markup generation. |
| `/blog repurpose <file>` | Repurpose for social, email, YouTube. |
| `/blog geo <file>` | AI citation readiness audit. |
| `/blog image [generate\|edit\|setup]` | AI image generation via Gemini. |
| `/blog audit [directory]` | Full-site blog health assessment. |
| `/blog cannibalization [directory]` | Detect keyword overlap across posts. |
| `/blog factcheck <file>` | Verify statistics against cited sources. |
| `/blog persona [create\|list\|apply]` | Manage writing personas. |
| `/blog taxonomy [sync\|audit\|suggest]` | Tag/category CMS management. |
| `/blog notebooklm <question>` | NotebookLM source-grounded research. |
| `/blog audio [generate\|voices\|setup]` | Audio narration via Gemini TTS. |
| `/blog google [command] [args]` | Google API: PSI, CrUX, GSC, GA4, NLP, YouTube, Keywords. |

> **22 sub-skills total**: 20 user-facing commands above + `blog-chart`
> (internal SVG generation) + `blog-image` (also callable internally by
> write/rewrite).

## Features

### 12 Content Templates
Auto-selected based on topic and intent: how-to guide, listicle, case study,
comparison, pillar page, product review, thought leadership, roundup,
tutorial, news analysis, data research, FAQ knowledge base.

### 5-Category Quality Scoring (100 Points)

| Category | Points | Focus |
|----------|--------|-------|
| Content Quality | 30 | Depth, readability, originality, engagement. |
| SEO Optimization | 25 | Headings, title, keywords, links, meta. |
| E-E-A-T Signals | 15 | Author, citations, trust, experience. |
| Technical Elements | 15 | Schema, images, speed, mobile, OG tags. |
| AI Citation Readiness | 15 | Citability, Q&A format, entity clarity. |

Bands: Exceptional (90-100), Strong (80-89), Acceptable (70-79), Below
Standard (60-69), Rewrite (<60).

### AI Content Detection
Burstiness scoring, known AI phrase detection (17 phrases), vocabulary
diversity analysis (TTR). Flags content that reads as AI-generated.

### Persona-Driven Writing
Configurable writing personas with the NNGroup 4-dimension tone framework.
Manage voice profiles per blog or author with readability bands
(Consumer / Professional / Technical) and style enforcement.

### Fact-Checking Pipeline
Statistics verification that fetches cited source URLs and scores claim
confidence (exact match, paraphrase, not found).

### Keyword Cannibalization Detection
Identifies keyword overlap across posts using local grep analysis or
DataForSEO API. Severity scoring with merge/differentiate recommendations.

### CMS Taxonomy Management
Tag and category management for WordPress REST, Shopify GraphQL, Ghost,
Strapi, and Sanity. Tag suggestion, sync, and audit workflows.

### Dual Optimization
Every article targets both Google rankings and AI citation platforms:
- **Google**: December 2025 Core Update compliance, E-E-A-T, schema markup,
  internal linking.
- **AI Citations**: Answer-first formatting, citation capsules, passage-level
  citability, FAQ schema.

### Visual Media
- Pixabay/Unsplash/Pexels image sourcing with alt text.
- AI image generation via Gemini (hero, inline, social cards), optional, free
  Google AI API key.
- Built-in SVG chart generation (bar, grouped bar, lollipop, donut, line,
  area, radar).
- YouTube embedding with `srcdoc` lazy loading, `noscript` AI crawler
  fallback, and quality scoring.
- Image density targets by content type.
- Image URL verification (HTTP 200 check before embedding).

### Google API Integration
13 commands across 4 credential tiers, all free at normal usage:
- **Tier 0** (API key): PageSpeed Insights, CrUX Core Web Vitals (25-week
  history), YouTube video search, NLP entity analysis.
- **Tier 1** (OAuth): Search Console performance, URL Inspection,
  Indexing API.
- **Tier 2** (GA4): Organic traffic reports.
- **Tier 3** (Ads): Google Ads Keyword Planner.

### NotebookLM Research
Query Google NotebookLM for source-grounded research from user-uploaded
documents. Tier 1 data quality with zero hallucination risk.

### Audio Narration
Generate audio narration via Gemini TTS. Three modes: summary (200-300
words), full article, two-speaker dialogue. 30 voices, 80+ languages.

### Platform Support
Next.js/MDX, Astro, Hugo, Jekyll, WordPress, Ghost, 11ty, Gatsby, and
static HTML.

## Architecture

```
opencode-blog/
├── AGENTS.md                       # Project instructions for OpenCode.
├── opencode.json                   # Project config (MCP, permissions).
├── agents/                         # Installs to ~/.config/opencode/agents/.
│   ├── blog.md                     # Primary orchestrator agent (mode: primary).
│   ├── blog-researcher.md          # Subagent: stats, sources, images, SERP.
│   ├── blog-writer.md              # Subagent: content generation.
│   ├── blog-seo.md                 # Subagent: on-page SEO validation.
│   └── blog-reviewer.md            # Subagent: 100-point quality scoring.
├── commands/                       # Installs to ~/.config/opencode/commands/.
│   └── blog.md                     # /blog slash command.
├── skills/                         # Installs to ~/.config/opencode/skills/.
│   ├── blog/                       # Knowledge skill: refs + templates + analyzer.
│   │   ├── SKILL.md
│   │   ├── references/             # 14 on-demand reference docs.
│   │   ├── templates/              # 12 content type templates.
│   │   └── scripts/analyze_blog.py # 5-category 100-point scorer.
│   ├── blog-write/SKILL.md         # …and 20 more workflow skills.
│   ├── blog-rewrite/SKILL.md
│   ├── blog-analyze/SKILL.md
│   ├── blog-brief/SKILL.md
│   ├── blog-calendar/SKILL.md
│   ├── blog-strategy/SKILL.md
│   ├── blog-outline/SKILL.md
│   ├── blog-seo-check/SKILL.md
│   ├── blog-schema/SKILL.md
│   ├── blog-repurpose/SKILL.md
│   ├── blog-geo/SKILL.md
│   ├── blog-audit/SKILL.md
│   ├── blog-chart/SKILL.md         # Internal: SVG chart generation.
│   ├── blog-image/                 # Gemini image generation (uses MCP).
│   ├── blog-cannibalization/SKILL.md
│   ├── blog-factcheck/SKILL.md
│   ├── blog-persona/SKILL.md
│   ├── blog-taxonomy/SKILL.md
│   ├── blog-notebooklm/            # NotebookLM source-grounded research.
│   ├── blog-audio/                 # Gemini TTS narration.
│   └── blog-google/                # Google API integration (PSI, CrUX, GSC, …).
├── scripts/analyze_blog.py         # Source for skills/blog/scripts/.
├── tests/                          # pytest test suite.
├── docs/                           # Long-form documentation.
├── .github/workflows/ci.yml        # CI pipeline.
├── install.sh / install.ps1        # Cross-platform installers.
├── uninstall.sh / uninstall.ps1
├── pyproject.toml                  # Python project config.
├── requirements.txt                # Python dependencies.
├── CONTRIBUTING.md
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## Requirements

- [OpenCode](https://opencode.ai) installed and configured.
- Python 3.11+ for the `analyze_blog.py` quality scorer.
- Optional: `pip install -r requirements.txt` for advanced analysis
  (readability scoring, schema detection).
- Optional: a free [Google AI API key](https://aistudio.google.com/apikey)
  for `/blog image`, `/blog audio`, and `/blog notebooklm`.

## Uninstall

Unix/macOS:

```bash
chmod +x uninstall.sh && ./uninstall.sh
```

Windows (PowerShell):

```powershell
.\uninstall.ps1
```

## Documentation

- [Installation Guide](docs/INSTALLATION.md): Unix, macOS, Windows, manual.
- [Command Reference](docs/COMMANDS.md): full reference with examples.
- [Architecture](docs/ARCHITECTURE.md): system design and component overview.
- [Templates](docs/TEMPLATES.md): template reference and customization.
- [Troubleshooting](docs/TROUBLESHOOTING.md): common issues and fixes.
- [MCP Integration](docs/MCP-INTEGRATION.md): optional MCP server setup.
- [OpenCode docs (mirror)](docs/OPENCODE.md): the OpenCode docs we built
  against.

## Contributing

Contributions welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License. See [LICENSE](LICENSE).

---

Built by [AgriciDaniel](https://github.com/AgriciDaniel) for OpenCode.

---

## Publishing Platform

For a full GUI-based content publishing workflow, see
[Rankenstein](https://rankenstein.pro) — research to publish in one
platform.

---

## Author

Built by [Agrici Daniel](https://agricidaniel.com/about) — AI Workflow
Architect.

- [Blog](https://agricidaniel.com/blog) — Deep dives on AI marketing
  automation.
- [AI Marketing Hub](https://www.skool.com/ai-marketing-hub) — Free
  community, 2,800+ members.
- [YouTube](https://www.youtube.com/@AgriciDaniel) — Tutorials and demos.
- [All open-source tools](https://github.com/AgriciDaniel)
