---
name: blog
description: >-
  Knowledge bundle for the opencode-blog ecosystem. Loads on demand to give
  the blog primary agent (and any sub-skill that needs them) access to the
  shared 6-pillar methodology, 100-point scoring rubric, 14 reference files,
  and 12 content templates. Sub-skills load this when they need cross-cutting
  guidance that should not be duplicated in every workflow file.
license: MIT
compatibility: opencode
metadata:
  audience: blog content engineers
  workflow: opencode
---

# Blog Knowledge Skill

This skill is a **knowledge bundle**, not a workflow. The orchestration
logic — command routing, subagent invocation, execution flow — lives in the
`blog` primary agent (`~/.config/opencode/agents/blog.md`). Workflow steps
for individual commands live in the matching sub-skills (`blog-write`,
`blog-rewrite`, `blog-analyze`, …).

Load this skill when you need shared methodology, the scoring rubric, or
template/reference indexes without re-reading the primary agent prompt.

## What's bundled here

- `references/google-landscape-2026.md` — December 2025 Core Update,
  E-E-A-T, algorithm changes.
- `references/geo-optimization.md` — GEO/AEO techniques, AI citation
  factors.
- `references/content-rules.md` — Structure, readability, answer-first
  formatting.
- `references/visual-media.md` — Image sourcing (Pixabay, Unsplash, Pexels),
  AI image generation, SVG chart integration.
- `references/quality-scoring.md` — Full 5-category scoring checklist
  (100 points).
- `references/platform-guides.md` — Platform-specific output formatting.
- `references/distribution-playbook.md` — Distribution strategy.
- `references/content-templates.md` — Template index.
- `references/eeat-signals.md` — Author E-E-A-T requirements, Person
  schema, experience markers.
- `references/ai-crawler-guide.md` — AI bot management, robots.txt, SSR
  requirements.
- `references/schema-stack.md` — Complete blog schema reference.
- `references/internal-linking.md` — Link architecture, anchor text,
  hub-and-spoke model.
- `references/video-embeds.md` — YouTube embedding patterns, quality
  criteria, VideoObject schema.
- `templates/` — 12 structural templates (how-to-guide, listicle,
  case-study, comparison, pillar-page, product-review, thought-leadership,
  roundup, tutorial, news-analysis, data-research, faq-knowledge).
- `scripts/analyze_blog.py` — 5-category 100-point scorer (CLI + JSON).

## Loading references

Use the `read` tool to pull a specific reference when the active workflow
needs it. Don't preemptively load everything — that wastes context. Common
references by command:

| Command | References to consider |
|---------|------------------------|
| `write` / `rewrite` | `content-rules`, `visual-media`, `eeat-signals`, `internal-linking`, `content-templates`, the chosen `templates/<type>.md`. |
| `analyze` / `audit` | `quality-scoring`, `eeat-signals`. |
| `geo` | `geo-optimization`, `ai-crawler-guide`. |
| `seo-check` | `internal-linking`, `schema-stack`. |
| `schema` | `schema-stack`, `eeat-signals`. |
| `strategy` / `calendar` | `geo-optimization`, `content-templates`, `distribution-playbook`. |
| `outline` | `content-rules`, `content-templates`. |
| `repurpose` | `distribution-playbook`. |

## The 6 Pillars (reference)

| Pillar | Implementation |
|--------|----------------|
| Answer-First Formatting | Every H2 opens with a 40-60 word stat-rich paragraph. |
| Real Sourced Data | Tier 1-3 sources only, inline attribution. |
| Visual Media | Pixabay/Unsplash images + Gemini-generated images + inline SVG charts + YouTube embeds. |
| FAQ Schema | Structured FAQ with 40-60 word answers. |
| Content Structure | 50-150 word chunks, question headings, proper heading hierarchy. |
| Freshness Signals | Updated within 30 days, dateModified schema. |

## Scoring Rubric (5 categories, 100 points)

| Category | Weight |
|----------|--------|
| Content Quality | 30 pts |
| SEO Optimization | 25 pts |
| E-E-A-T Signals | 15 pts |
| Technical Elements | 15 pts |
| AI Citation Readiness | 15 pts |

Bands: 90-100 Exceptional · 80-89 Strong · 70-79 Acceptable · 60-69 Below
Standard · <60 Rewrite. Full criteria are in
`references/quality-scoring.md`. Run
`python3 ~/.config/opencode/skills/blog/scripts/analyze_blog.py <file>
--json` for objective metrics.

## Quality Gates (hard rules)

| Rule | Threshold |
|------|-----------|
| Fabricated statistics | Zero tolerance — every number needs a named source. |
| Paragraph length | Never > 150 words. |
| Heading hierarchy | Never skip levels (H1 → H2 → H3). |
| Source tier | Tier 1-3 only. |
| Image alt text | Required on every image. |
| Self-promotion | Max 1 brand mention. |
| Chart diversity | No duplicate chart types in one post. |

## When NOT to load this skill

- The primary agent is already executing a sub-skill that has its own
  complete instructions — load the sub-skill alone.
- You only need the scoring rubric — call `analyze_blog.py` directly.
- You're inside a specialist subagent (`blog-researcher`, `blog-writer`,
  etc.) whose system prompt already covers the relevant rules.
