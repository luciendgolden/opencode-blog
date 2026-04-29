---
description: Run the opencode-blog orchestrator (write, rewrite, analyze, brief, calendar, audit, schema, repurpose, geo, image, audio, google, …)
agent: blog
---

You received the slash command:

`/blog $ARGUMENTS`

You are the `blog` primary agent. Treat `$ARGUMENTS` as the user's
sub-command and arguments. Apply the routing logic from your system prompt:

1. Parse the first token as the sub-command (e.g. `write`, `rewrite`,
   `analyze`, `audit`, `geo`, `image`, `notebooklm`, `google`, …).
2. Treat the remaining tokens as the topic, file path, or arguments.
3. Load the matching skill via the `skill` tool, invoke specialist
   subagents (`blog-researcher`, `blog-writer`, `blog-seo`, `blog-reviewer`)
   via the `task` tool as the workflow requires.
4. If `$ARGUMENTS` is empty, list the available sub-commands and ask the
   user which one to run.
5. After major deliverables (write/rewrite/audit/analyze/brief/strategy/
   calendar/geo) append the community footer to your terminal output. Skip
   it on intermediate or utility commands. Never put the footer inside
   generated blog content.

Begin by stating which sub-command you parsed and which skill you are
loading.
