# File: acp.md
---
title: "ACP Support"
source: "https://opencode.ai/docs/acp/"
description: "Use OpenCode in any ACP-compatible editor."
---

OpenCode supports the [Agent Client Protocol](https://agentclientprotocol.com) or (ACP), allowing you to use it directly in compatible editors and IDEs.

> **Tip:** For a list of editors and tools that support ACP, check out the [ACP progress report](https://zed.dev/blog/acp-progress-report#available-now).

ACP is an open protocol that standardizes communication between code editors and AI coding agents.

---

## [Configure](#configure)

To use OpenCode via ACP, configure your editor to run the `opencode acp` command.

The command starts OpenCode as an ACP-compatible subprocess that communicates with your editor over JSON-RPC via stdio.

Below are examples for popular editors that support ACP.

---

### [Zed](#zed)

Add to your [Zed](https://zed.dev) configuration (`~/.config/zed/settings.json`):

// ~/.config/zed/settings.json
```json
{
  "agent_servers": {
    "OpenCode": {
      "command": "opencode",
      "args": ["acp"]
    }
  }
}
```

To open it, use the `agent: new thread` action in the **Command Palette**.

You can also bind a keyboard shortcut by editing your `keymap.json`:

// keymap.json
```json
[
  {
    "bindings": {
      "cmd-alt-o": [
        "agent::NewExternalAgentThread",
        {
          "agent": {
            "custom": {
              "name": "OpenCode",
              "command": {
                "command": "opencode",
                "args": ["acp"]
              }
            }
          }
        }
      ]
    }
  }
]
```

---

### [JetBrains IDEs](#jetbrains-ides)

Add to your [JetBrains IDE](https://www.jetbrains.com/) acp.json according to the [documentation](https://www.jetbrains.com/help/ai-assistant/acp.html):

// acp.json
```json
{
  "agent_servers": {
    "OpenCode": {
      "command": "/absolute/path/bin/opencode",
      "args": ["acp"]
    }
  }
}
```

To open it, use the new ‘OpenCode’ agent in the AI Chat agent selector.

---

### [Avante.nvim](#avantenvim)

Add to your [Avante.nvim](https://github.com/yetone/avante.nvim) configuration:

```lua
{
  acp_providers = {
    ["opencode"] = {
      command = "opencode",
      args = { "acp" }
    }
  }
}
```

If you need to pass environment variables:

```lua
{
  acp_providers = {
    ["opencode"] = {
      command = "opencode",
      args = { "acp" },
      env = {
        OPENCODE_API_KEY = os.getenv("OPENCODE_API_KEY")
      }
    }
  }
}
```

---

### [CodeCompanion.nvim](#codecompanionnvim)

To use OpenCode as an ACP agent in [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim), add the following to your Neovim config:

```lua
require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = {
        name = "opencode",
        model = "claude-sonnet-4",
      },
    },
  },
})
```

This config sets up CodeCompanion to use OpenCode as the ACP agent for chat.

If you need to pass environment variables (like `OPENCODE_API_KEY`), refer to [Configuring Adapters: Environment Variables](https://codecompanion.olimorris.dev/getting-started#setting-an-api-key) in the CodeCompanion.nvim documentation for full details.

## [Support](#support)

OpenCode works the same via ACP as it does in the terminal. All features are supported:

> **Note:** Some built-in slash commands like `/undo` and `/redo` are currently unsupported.

- Built-in tools (file operations, terminal commands, etc.)

- Custom tools and slash commands

- MCP servers configured in your OpenCode config

- Project-specific rules from `AGENTS.md`

- Custom formatters and linters

- Agents and permissions system


---
# File: agents.md
---
title: "Agents"
source: "https://opencode.ai/docs/agents/"
description: "Configure and use specialized agents."
---

Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.

> **Tip:** Use the plan agent to analyze code and review suggestions without making any code changes.

You can switch between agents during a session or invoke them with the `@` mention.

---

## [Types](#types)

There are two types of agents in OpenCode; primary agents and subagents.

---

### [Primary agents](#primary-agents)

Primary agents are the main assistants you interact with directly. You can cycle through them using the **Tab** key, or your configured `switch_agent` keybind. These agents handle your main conversation. Tool access is configured via permissions — for example, Build has all tools enabled while Plan is restricted.

> **Tip:** You can use the **Tab** key to switch between primary agents during a session.

OpenCode comes with two built-in primary agents, **Build** and **Plan**. We’ll look at these below.

---

### [Subagents](#subagents)

Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by **@ mentioning** them in your messages.

OpenCode comes with two built-in subagents, **General** and **Explore**. We’ll look at this below.

---

## [Built-in](#built-in)

OpenCode comes with two built-in primary agents and two built-in subagents.

---

### [Use build](#use-build)

*Mode*: `primary`

Build is the **default** primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.

---

### [Use plan](#use-plan)

*Mode*: `primary`

A restricted agent designed for planning and analysis. We use a permission system to give you more control and prevent unintended changes. By default, all of the following are set to `ask`:

- `file edits`: All writes, patches, and edits

- `bash`: All bash commands

This agent is useful when you want the LLM to analyze code, suggest changes, or create plans without making any actual modifications to your codebase.

---

### [Use general](#use-general)

*Mode*: `subagent`

A general-purpose agent for researching complex questions and executing multi-step tasks. Has full tool access (except todo), so it can make file changes when needed. Use this to run multiple units of work in parallel.

---

### [Use explore](#use-explore)

*Mode*: `subagent`

A fast, read-only agent for exploring codebases. Cannot modify files. Use this when you need to quickly find files by patterns, search code for keywords, or answer questions about the codebase.

---

### [Use compaction](#use-compaction)

*Mode*: `primary`

Hidden system agent that compacts long context into a smaller summary. It runs automatically when needed and is not selectable in the UI.

---

### [Use title](#use-title)

*Mode*: `primary`

Hidden system agent that generates short session titles. It runs automatically and is not selectable in the UI.

---

### [Use summary](#use-summary)

*Mode*: `primary`

Hidden system agent that creates session summaries. It runs automatically and is not selectable in the UI.

---

## [Usage](#usage)

- For primary agents, use the **Tab** key to cycle through them during a session. You can also use your configured `switch_agent` keybind.

- Subagents can be invoked: **Automatically** by primary agents for specialized tasks based on their descriptions.

- Manually by **@ mentioning** a subagent in your message. For example. ```txt @general help me search for this function ```

- **Navigation between sessions**: When subagents create child sessions, use `session_child_first` (default: **+Down**) to enter the first child session from the parent.

- Once you are in a child session, use: `session_child_cycle` (default: **Right**) to cycle to the next child session

- `session_child_cycle_reverse` (default: **Left**) to cycle to the previous child session

- `session_parent` (default: **Up**) to return to the parent session

This lets you switch between the main conversation and specialized subagent work.

---

## [Configure](#configure)

You can customize the built-in agents or create your own through configuration. Agents can be configured in two ways:

---

### [JSON](#json)

Configure agents in your `opencode.json` config file:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "{file:./prompts/build.txt}",
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "plan": {
      "mode": "primary",
      "model": "anthropic/claude-haiku-4-20250514",
      "tools": {
        "write": false,
        "edit": false,
        "bash": false
      }
    },
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "tools": {
        "write": false,
        "edit": false
      }
    }
  }
}
```

---

### [Markdown](#markdown)

You can also define agents using markdown files. Place them in:

- Global: `~/.config/opencode/agents/`

- Per-project: `.opencode/agents/`

// ~/.config/opencode/agents/review.md
```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
---

You are in code review mode. Focus on:

- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations

Provide constructive feedback without making direct changes.
```

The markdown file name becomes the agent name. For example, `review.md` creates a `review` agent.

---

## [Options](#options)

Let’s look at these configuration options in detail.

---

### [Description](#description)

Use the `description` option to provide a brief description of what the agent does and when to use it.

// opencode.json
```json
{
  "agent": {
    "review": {
      "description": "Reviews code for best practices and potential issues"
    }
  }
}
```

This is a **required** config option.

---

### [Temperature](#temperature)

Control the randomness and creativity of the LLM’s responses with the `temperature` config.

Lower values make responses more focused and deterministic, while higher values increase creativity and variability.

// opencode.json
```json
{
  "agent": {
    "plan": {
      "temperature": 0.1
    },
    "creative": {
      "temperature": 0.8
    }
  }
}
```

Temperature values typically range from 0.0 to 1.0:

- **0.0-0.2**: Very focused and deterministic responses, ideal for code analysis and planning

- **0.3-0.5**: Balanced responses with some creativity, good for general development tasks

- **0.6-1.0**: More creative and varied responses, useful for brainstorming and exploration

// opencode.json
```json
{
  "agent": {
    "analyze": {
      "temperature": 0.1,
      "prompt": "{file:./prompts/analysis.txt}"
    },
    "build": {
      "temperature": 0.3
    },
    "brainstorm": {
      "temperature": 0.7,
      "prompt": "{file:./prompts/creative.txt}"
    }
  }
}
```

If no temperature is specified, OpenCode uses model-specific defaults; typically 0 for most models, 0.55 for Qwen models.

---

### [Max steps](#max-steps)

Control the maximum number of agentic iterations an agent can perform before being forced to respond with text only. This allows users who wish to control costs to set a limit on agentic actions.

If this is not set, the agent will continue to iterate until the model chooses to stop or the user interrupts the session.

// opencode.json
```json
{
  "agent": {
    "quick-thinker": {
      "description": "Fast reasoning with limited iterations",
      "prompt": "You are a quick thinker. Solve problems with minimal steps.",
      "steps": 5
    }
  }
}
```

When the limit is reached, the agent receives a special system prompt instructing it to respond with a summarization of its work and recommended remaining tasks.

> **Caution:** The legacy `maxSteps` field is deprecated. Use `steps` instead.

---

### [Disable](#disable)

Set to `true` to disable the agent.

// opencode.json
```json
{
  "agent": {
    "review": {
      "disable": true
    }
  }
}
```

---

### [Prompt](#prompt)

Specify a custom system prompt file for this agent with the `prompt` config. The prompt file should contain instructions specific to the agent’s purpose.

// opencode.json
```json
{
  "agent": {
    "review": {
      "prompt": "{file:./prompts/code-review.txt}"
    }
  }
}
```

This path is relative to where the config file is located. So this works for both the global OpenCode config and the project specific config.

---

### [Model](#model)

Use the `model` config to override the model for this agent. Useful for using different models optimized for different tasks. For example, a faster model for planning, a more capable model for implementation.

> **Tip:** If you don’t specify a model, primary agents use the [model globally configured](/docs/config#models) while subagents will use the model of the primary agent that invoked the subagent.

// opencode.json
```json
{
  "agent": {
    "plan": {
      "model": "anthropic/claude-haiku-4-20250514"
    }
  }
}
```

The model ID in your OpenCode config uses the format `provider/model-id`. For example, if you’re using [OpenCode Zen](/docs/zen), you would use `opencode/gpt-5.1-codex` for GPT 5.1 Codex.

---

### [Tools (deprecated)](#tools-deprecated)

`tools` is **deprecated**. Prefer the agent’s [`permission`](#permissions) field for new configs, updates and more fine-grained control.

Allows you to control which tools are available in this agent. You can enable or disable specific tools by setting them to `true` or `false`. In an agent’s `tools` config, `true` is equivalent to `{"*": "allow"}` permission and `false` is equivalent to `{"*": "deny"}` permission.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "tools": {
    "write": true,
    "bash": true
  },
  "agent": {
    "plan": {
      "tools": {
        "write": false,
        "bash": false
      }
    }
  }
}
```

> **Note:** The agent-specific config overrides the global config.

You can also use wildcards in legacy `tools` entries to control multiple tools at once. For example, to disable all tools from an MCP server:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "readonly": {
      "tools": {
        "mymcp_*": false,
        "write": false,
        "edit": false
      }
    }
  }
}
```

[Learn more about tools](/docs/tools).

---

### [Permissions](#permissions)

You can configure permissions to manage what actions an agent can take. Currently, the permissions for the `edit`, `bash`, and `webfetch` tools can be configured to:

- `"ask"` — Prompt for approval before running the tool

- `"allow"` — Allow all operations without approval

- `"deny"` — Disable the tool

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "deny"
  }
}
```

You can override these permissions per agent.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "deny"
  },
  "agent": {
    "build": {
      "permission": {
        "edit": "ask"
      }
    }
  }
}
```

You can also set permissions in Markdown agents.

// ~/.config/opencode/agents/review.md
```markdown
---
description: Code review without edits
mode: subagent
permission:
  edit: deny
  bash:
    "*": ask
    "git diff": allow
    "git log*": allow
    "grep *": allow
  webfetch: deny
---

Only analyze code and suggest changes.
```

You can set permissions for specific bash commands.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "git push": "ask",
          "grep *": "allow"
        }
      }
    }
  }
}
```

This can take a glob pattern.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "git *": "ask"
        }
      }
    }
  }
}
```

And you can also use the `*` wildcard to manage permissions for all commands. Since the last matching rule takes precedence, put the `*` wildcard first and specific rules after.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "*": "ask",
          "git status *": "allow"
        }
      }
    }
  }
}
```

[Learn more about permissions](/docs/permissions).

---

### [Mode](#mode)

Control the agent’s mode with the `mode` config. The `mode` option is used to determine how the agent can be used.

// opencode.json
```json
{
  "agent": {
    "review": {
      "mode": "subagent"
    }
  }
}
```

The `mode` option can be set to `primary`, `subagent`, or `all`. If no `mode` is specified, it defaults to `all`.

---

### [Hidden](#hidden)

Hide a subagent from the `@` autocomplete menu with `hidden: true`. Useful for internal subagents that should only be invoked programmatically by other agents via the Task tool.

// opencode.json
```json
{
  "agent": {
    "internal-helper": {
      "mode": "subagent",
      "hidden": true
    }
  }
}
```

This only affects user visibility in the autocomplete menu. Hidden agents can still be invoked by the model via the Task tool if permissions allow.

> **Note:** Only applies to `mode: subagent` agents.

---

### [Task permissions](#task-permissions)

Control which subagents an agent can invoke via the Task tool with `permission.task`. Uses glob patterns for flexible matching.

// opencode.json
```json
{
  "agent": {
    "orchestrator": {
      "mode": "primary",
      "permission": {
        "task": {
          "*": "deny",
          "orchestrator-*": "allow",
          "code-reviewer": "ask"
        }
      }
    }
  }
}
```

When set to `deny`, the subagent is removed from the Task tool description entirely, so the model won’t attempt to invoke it.

> **Tip:** Rules are evaluated in order, and the **last matching rule wins**. In the example above, `orchestrator-planner` matches both `*` (deny) and `orchestrator-*` (allow), but since `orchestrator-*` comes after `*`, the result is `allow`.

> **Tip:** Users can always invoke any subagent directly via the `@` autocomplete menu, even if the agent’s task permissions would deny it.

---

### [Color](#color)

Customize the agent’s visual appearance in the UI with the `color` option. This affects how the agent appears in the interface.

Use a valid hex color (e.g., `#FF5733`) or theme color: `primary`, `secondary`, `accent`, `success`, `warning`, `error`, `info`.

// opencode.json
```json
{
  "agent": {
    "creative": {
      "color": "#ff6b6b"
    },
    "code-reviewer": {
      "color": "accent"
    }
  }
}
```

---

### [Top P](#top-p)

Control response diversity with the `top_p` option. Alternative to temperature for controlling randomness.

// opencode.json
```json
{
  "agent": {
    "brainstorm": {
      "top_p": 0.9
    }
  }
}
```

Values range from 0.0 to 1.0. Lower values are more focused, higher values more diverse.

---

### [Additional](#additional)

Any other options you specify in your agent configuration will be **passed through directly** to the provider as model options. This allows you to use provider-specific features and parameters.

For example, with OpenAI’s reasoning models, you can control the reasoning effort:

// opencode.json
```json
{
  "agent": {
    "deep-thinker": {
      "description": "Agent that uses high reasoning effort for complex problems",
      "model": "openai/gpt-5",
      "reasoningEffort": "high",
      "textVerbosity": "low"
    }
  }
}
```

These additional options are model and provider-specific. Check your provider’s documentation for available parameters.

> **Tip:** Run `opencode models` to see a list of the available models.

---

## [Create agents](#create-agents)

You can create new agents using the following command:

```bash
opencode agent create
```

This interactive command will:

- Ask where to save the agent; global or project-specific.

- Description of what the agent should do.

- Generate an appropriate system prompt and identifier.

- Let you select which tools the agent can access.

- Finally, create a markdown file with the agent configuration.

---

## [Use cases](#use-cases)

Here are some common use cases for different agents.

- **Build agent**: Full development work with all tools enabled

- **Plan agent**: Analysis and planning without making changes

- **Review agent**: Code review with read-only access plus documentation tools

- **Debug agent**: Focused on investigation with bash and read tools enabled

- **Docs agent**: Documentation writing with file operations but no system commands

---

## [Examples](#examples)

Here are some example agents you might find useful.

> **Tip:** Do you have an agent you’d like to share? [Submit a PR](https://github.com/anomalyco/opencode).

---

### [Documentation agent](#documentation-agent)

// ~/.config/opencode/agents/docs-writer.md
```markdown
---
description: Writes and maintains project documentation
mode: subagent
tools:
  bash: false
---

You are a technical writer. Create clear, comprehensive documentation.

Focus on:

- Clear explanations
- Proper structure
- Code examples
- User-friendly language
```

---

### [Security auditor](#security-auditor)

// ~/.config/opencode/agents/security-auditor.md
```markdown
---
description: Performs security audits and identifies vulnerabilities
mode: subagent
tools:
  write: false
  edit: false
---

You are a security expert. Focus on identifying potential security issues.

Look for:

- Input validation vulnerabilities
- Authentication and authorization flaws
- Data exposure risks
- Dependency vulnerabilities
- Configuration security issues
```


---
# File: cli.md
---
title: "CLI"
source: "https://opencode.ai/docs/cli/"
description: "OpenCode CLI options and commands."
---

The OpenCode CLI by default starts the [TUI](/docs/tui) when run without any arguments.

```bash
opencode
```

But it also accepts commands as documented on this page. This allows you to interact with OpenCode programmatically.

```bash
opencode run "Explain how closures work in JavaScript"
```

---

### [tui](#tui)

Start the OpenCode terminal user interface.

```bash
opencode [project]
```

#### [Flags](#flags)

FlagShortDescription--continue-cContinue the last session--session-sSession ID to continue--forkFork the session when continuing (use with --continue or --session)--promptPrompt to use--model-mModel to use in the form of provider/model--agentAgent to use--portPort to listen on--hostnameHostname to listen on

---

## [Commands](#commands)

The OpenCode CLI also has the following commands.

---

### [agent](#agent)

Manage agents for OpenCode.

```bash
opencode agent [command]
```

---

### [attach](#attach)

Attach a terminal to an already running OpenCode backend server started via `serve` or `web` commands.

```bash
opencode attach [url]
```

This allows using the TUI with a remote OpenCode backend. For example:

```bash
# Start the backend server for web/mobile access
opencode web --port 4096 --hostname 0.0.0.0

# In another terminal, attach the TUI to the running backend
opencode attach http://10.20.30.40:4096
```

#### [Flags](#flags-1)

FlagShortDescription--dirWorking directory to start TUI in--session-sSession ID to continue

---

#### [create](#create)

Create a new agent with custom configuration.

```bash
opencode agent create
```

This command will guide you through creating a new agent with a custom system prompt and tool configuration.

---

#### [list](#list)

List all available agents.

```bash
opencode agent list
```

---

### [auth](#auth)

Command to manage credentials and login for providers.

```bash
opencode auth [command]
```

---

#### [login](#login)

OpenCode is powered by the provider list at [Models.dev](https://models.dev), so you can use `opencode auth login` to configure API keys for any provider you’d like to use. This is stored in `~/.local/share/opencode/auth.json`.

```bash
opencode auth login
```

When OpenCode starts up it loads the providers from the credentials file. And if there are any keys defined in your environments or a `.env` file in your project.

---

#### [list](#list-1)

Lists all the authenticated providers as stored in the credentials file.

```bash
opencode auth list
```

Or the short version.

```bash
opencode auth ls
```

---

#### [logout](#logout)

Logs you out of a provider by clearing it from the credentials file.

```bash
opencode auth logout
```

---

### [github](#github)

Manage the GitHub agent for repository automation.

```bash
opencode github [command]
```

---

#### [install](#install)

Install the GitHub agent in your repository.

```bash
opencode github install
```

This sets up the necessary GitHub Actions workflow and guides you through the configuration process. [Learn more](/docs/github).

---

#### [run](#run)

Run the GitHub agent. This is typically used in GitHub Actions.

```bash
opencode github run
```

##### [Flags](#flags-2)

FlagDescription--eventGitHub mock event to run the agent for--tokenGitHub personal access token

---

### [mcp](#mcp)

Manage Model Context Protocol servers.

```bash
opencode mcp [command]
```

---

#### [add](#add)

Add an MCP server to your configuration.

```bash
opencode mcp add
```

This command will guide you through adding either a local or remote MCP server.

---

#### [list](#list-2)

List all configured MCP servers and their connection status.

```bash
opencode mcp list
```

Or use the short version.

```bash
opencode mcp ls
```

---

#### [auth](#auth-1)

Authenticate with an OAuth-enabled MCP server.

```bash
opencode mcp auth [name]
```

If you don’t provide a server name, you’ll be prompted to select from available OAuth-capable servers.

You can also list OAuth-capable servers and their authentication status.

```bash
opencode mcp auth list
```

Or use the short version.

```bash
opencode mcp auth ls
```

---

#### [logout](#logout-1)

Remove OAuth credentials for an MCP server.

```bash
opencode mcp logout [name]
```

---

#### [debug](#debug)

Debug OAuth connection issues for an MCP server.

```bash
opencode mcp debug
```

---

### [models](#models)

List all available models from configured providers.

```bash
opencode models [provider]
```

This command displays all models available across your configured providers in the format `provider/model`.

This is useful for figuring out the exact model name to use in [your config](/docs/config/).

You can optionally pass a provider ID to filter models by that provider.

```bash
opencode models anthropic
```

#### [Flags](#flags-3)

FlagDescription--refreshRefresh the models cache from models.dev--verboseUse more verbose model output (includes metadata like costs)

Use the `--refresh` flag to update the cached model list. This is useful when new models have been added to a provider and you want to see them in OpenCode.

```bash
opencode models --refresh
```

---

### [run](#run-1)

Run opencode in non-interactive mode by passing a prompt directly.

```bash
opencode run [message..]
```

This is useful for scripting, automation, or when you want a quick answer without launching the full TUI. For example.

```bash
opencode run Explain the use of context in Go
```

You can also attach to a running `opencode serve` instance to avoid MCP server cold boot times on every run:

```bash
# Start a headless server in one terminal
opencode serve

# In another terminal, run commands that attach to it
opencode run --attach http://localhost:4096 "Explain async/await in JavaScript"
```

#### [Flags](#flags-4)

FlagShortDescription--commandThe command to run, use message for args--continue-cContinue the last session--session-sSession ID to continue--forkFork the session when continuing (use with --continue or --session)--shareShare the session--model-mModel to use in the form of provider/model--agentAgent to use--file-fFile(s) to attach to message--formatFormat: default (formatted) or json (raw JSON events)--titleTitle for the session (uses truncated prompt if no value provided)--attachAttach to a running opencode server (e.g., http://localhost:4096)--portPort for the local server (defaults to random port)

---

### [serve](#serve)

Start a headless OpenCode server for API access. Check out the [server docs](/docs/server) for the full HTTP interface.

```bash
opencode serve
```

This starts an HTTP server that provides API access to opencode functionality without the TUI interface. Set `OPENCODE_SERVER_PASSWORD` to enable HTTP basic auth (username defaults to `opencode`).

#### [Flags](#flags-5)

FlagDescription--portPort to listen on--hostnameHostname to listen on--mdnsEnable mDNS discovery--corsAdditional browser origin(s) to allow CORS

---

### [session](#session)

Manage OpenCode sessions.

```bash
opencode session [command]
```

---

#### [list](#list-3)

List all OpenCode sessions.

```bash
opencode session list
```

##### [Flags](#flags-6)

FlagShortDescription--max-count-nLimit to N most recent sessions--formatOutput format: table or json (table)

---

### [stats](#stats)

Show token usage and cost statistics for your OpenCode sessions.

```bash
opencode stats
```

#### [Flags](#flags-7)

FlagDescription--daysShow stats for the last N days (all time)--toolsNumber of tools to show (all)--modelsShow model usage breakdown (hidden by default). Pass a number to show top N--projectFilter by project (all projects, empty string: current project)

---

### [export](#export)

Export session data as JSON.

```bash
opencode export [sessionID]
```

If you don’t provide a session ID, you’ll be prompted to select from available sessions.

---

### [import](#import)

Import session data from a JSON file or OpenCode share URL.

```bash
opencode import
```

You can import from a local file or an OpenCode share URL.

```bash
opencode import session.json
opencode import https://opncd.ai/s/abc123
```

---

### [web](#web)

Start a headless OpenCode server with a web interface.

```bash
opencode web
```

This starts an HTTP server and opens a web browser to access OpenCode through a web interface. Set `OPENCODE_SERVER_PASSWORD` to enable HTTP basic auth (username defaults to `opencode`).

#### [Flags](#flags-8)

FlagDescription--portPort to listen on--hostnameHostname to listen on--mdnsEnable mDNS discovery--corsAdditional browser origin(s) to allow CORS

---

### [acp](#acp)

Start an ACP (Agent Client Protocol) server.

```bash
opencode acp
```

This command starts an ACP server that communicates via stdin/stdout using nd-JSON.

#### [Flags](#flags-9)

FlagDescription--cwdWorking directory--portPort to listen on--hostnameHostname to listen on

---

### [uninstall](#uninstall)

Uninstall OpenCode and remove all related files.

```bash
opencode uninstall
```

#### [Flags](#flags-10)

FlagShortDescription--keep-config-cKeep configuration files--keep-data-dKeep session data and snapshots--dry-runShow what would be removed without removing--force-fSkip confirmation prompts

---

### [upgrade](#upgrade)

Updates opencode to the latest version or a specific version.

```bash
opencode upgrade [target]
```

To upgrade to the latest version.

```bash
opencode upgrade
```

To upgrade to a specific version.

```bash
opencode upgrade v0.1.48
```

#### [Flags](#flags-11)

FlagShortDescription--method-mThe installation method that was used; curl, npm, pnpm, bun, brew

---

## [Global Flags](#global-flags)

The opencode CLI takes the following global flags.

FlagShortDescription--help-hDisplay help--version-vPrint version number--print-logsPrint logs to stderr--log-levelLog level (DEBUG, INFO, WARN, ERROR)

---

## [Environment variables](#environment-variables)

OpenCode can be configured using environment variables.

VariableTypeDescriptionOPENCODE_AUTO_SHAREbooleanAutomatically share sessionsOPENCODE_GIT_BASH_PATHstringPath to Git Bash executable on WindowsOPENCODE_CONFIGstringPath to config fileOPENCODE_TUI_CONFIGstringPath to TUI config fileOPENCODE_CONFIG_DIRstringPath to config directoryOPENCODE_CONFIG_CONTENTstringInline json config contentOPENCODE_DISABLE_AUTOUPDATEbooleanDisable automatic update checksOPENCODE_DISABLE_PRUNEbooleanDisable pruning of old dataOPENCODE_DISABLE_TERMINAL_TITLEbooleanDisable automatic terminal title updatesOPENCODE_PERMISSIONstringInlined json permissions configOPENCODE_DISABLE_DEFAULT_PLUGINSbooleanDisable default pluginsOPENCODE_DISABLE_LSP_DOWNLOADbooleanDisable automatic LSP server downloadsOPENCODE_ENABLE_EXPERIMENTAL_MODELSbooleanEnable experimental modelsOPENCODE_DISABLE_AUTOCOMPACTbooleanDisable automatic context compactionOPENCODE_DISABLE_CLAUDE_CODEbooleanDisable reading from .claude (prompt + skills)OPENCODE_DISABLE_CLAUDE_CODE_PROMPTbooleanDisable reading ~/.claude/CLAUDE.mdOPENCODE_DISABLE_CLAUDE_CODE_SKILLSbooleanDisable loading .claude/skillsOPENCODE_DISABLE_MODELS_FETCHbooleanDisable fetching models from remote sourcesOPENCODE_FAKE_VCSstringFake VCS provider for testing purposesOPENCODE_DISABLE_FILETIME_CHECKbooleanDisable file time checking for optimizationOPENCODE_CLIENTstringClient identifier (defaults to cli)OPENCODE_ENABLE_EXAbooleanEnable Exa web search toolsOPENCODE_SERVER_PASSWORDstringEnable basic auth for serve/webOPENCODE_SERVER_USERNAMEstringOverride basic auth username (default opencode)OPENCODE_MODELS_URLstringCustom URL for fetching models configuration

---

### [Experimental](#experimental)

These environment variables enable experimental features that may change or be removed.

VariableTypeDescriptionOPENCODE_EXPERIMENTALbooleanEnable all experimental featuresOPENCODE_EXPERIMENTAL_ICON_DISCOVERYbooleanEnable icon discoveryOPENCODE_EXPERIMENTAL_DISABLE_COPY_ON_SELECTbooleanDisable copy on select in TUIOPENCODE_EXPERIMENTAL_BASH_DEFAULT_TIMEOUT_MSnumberDefault timeout for bash commands in msOPENCODE_EXPERIMENTAL_OUTPUT_TOKEN_MAXnumberMax output tokens for LLM responsesOPENCODE_EXPERIMENTAL_FILEWATCHERbooleanEnable file watcher for entire dirOPENCODE_EXPERIMENTAL_OXFMTbooleanEnable oxfmt formatterOPENCODE_EXPERIMENTAL_LSP_TOOLbooleanEnable experimental LSP toolOPENCODE_EXPERIMENTAL_DISABLE_FILEWATCHERbooleanDisable file watcherOPENCODE_EXPERIMENTAL_EXAbooleanEnable experimental Exa featuresOPENCODE_EXPERIMENTAL_LSP_TYbooleanEnable TY LSP for python filesOPENCODE_EXPERIMENTAL_MARKDOWNbooleanEnable experimental markdown featuresOPENCODE_EXPERIMENTAL_PLAN_MODEbooleanEnable plan mode


---
# File: commands.md
---
title: "Commands"
source: "https://opencode.ai/docs/commands/"
description: "Create custom commands for repetitive tasks."
---

Custom commands let you specify a prompt you want to run when that command is executed in the TUI.

```bash
/my-command
```

Custom commands are in addition to the built-in commands like `/init`, `/undo`, `/redo`, `/share`, `/help`. [Learn more](/docs/tui#commands).

---

## [Create command files](#create-command-files)

Create markdown files in the `commands/` directory to define custom commands.

Create `.opencode/commands/test.md`:

// .opencode/commands/test.md
```md
---
description: Run tests with coverage
agent: build
model: anthropic/claude-3-5-sonnet-20241022
---

Run the full test suite with coverage report and show any failures.
Focus on the failing tests and suggest fixes.
```

The frontmatter defines command properties. The content becomes the template.

Use the command by typing `/` followed by the command name.

```bash
"/test"
```

---

## [Configure](#configure)

You can add custom commands through the OpenCode config or by creating markdown files in the `commands/` directory.

---

### [JSON](#json)

Use the `command` option in your OpenCode [config](/docs/config):

// opencode.jsonc
```json
{
  "$schema": "https://opencode.ai/config.json",
  "command": {
    // This becomes the name of the command
    "test": {
      // This is the prompt that will be sent to the LLM
      "template": "Run the full test suite with coverage report and show any failures.\nFocus on the failing tests and suggest fixes.",
      // This is shown as the description in the TUI
      "description": "Run tests with coverage",
      "agent": "build",
      "model": "anthropic/claude-3-5-sonnet-20241022"
    }
  }
}
```

Now you can run this command in the TUI:

```bash
/test
```

---

### [Markdown](#markdown)

You can also define commands using markdown files. Place them in:

- Global: `~/.config/opencode/commands/`

- Per-project: `.opencode/commands/`

// ~/.config/opencode/commands/test.md
```markdown
---
description: Run tests with coverage
agent: build
model: anthropic/claude-3-5-sonnet-20241022
---

Run the full test suite with coverage report and show any failures.
Focus on the failing tests and suggest fixes.
```

The markdown file name becomes the command name. For example, `test.md` lets you run:

```bash
/test
```

---

## [Prompt config](#prompt-config)

The prompts for the custom commands support several special placeholders and syntax.

---

### [Arguments](#arguments)

Pass arguments to commands using the `$ARGUMENTS` placeholder.

// .opencode/commands/component.md
```md
---
description: Create a new component
---

Create a new React component named $ARGUMENTS with TypeScript support.
Include proper typing and basic structure.
```

Run the command with arguments:

```bash
/component Button
```

And `$ARGUMENTS` will be replaced with `Button`.

You can also access individual arguments using positional parameters:

- `$1` - First argument

- `$2` - Second argument

- `$3` - Third argument

- And so on…

For example:

// .opencode/commands/create-file.md
```md
---
description: Create a new file with content
---

Create a file named $1 in the directory $2
with the following content: $3
```

Run the command:

```bash
/create-file config.json src "{ \"key\": \"value\" }"
```

This replaces:

- `$1` with `config.json`

- `$2` with `src`

- `$3` with `{ "key": "value" }`

---

### [Shell output](#shell-output)

Use *!`command`* to inject [bash command](/docs/tui#bash-commands) output into your prompt.

For example, to create a custom command that analyzes test coverage:

// .opencode/commands/analyze-coverage.md
```md
---
description: Analyze test coverage
---

Here are the current test results:
!`npm test`

Based on these results, suggest improvements to increase coverage.
```

Or to review recent changes:

// .opencode/commands/review-changes.md
```md
---
description: Review recent changes
---

Recent git commits:
!`git log --oneline -10`

Review these changes and suggest any improvements.
```

Commands run in your project’s root directory and their output becomes part of the prompt.

---

### [File references](#file-references)

Include files in your command using `@` followed by the filename.

// .opencode/commands/review-component.md
```md
---
description: Review component
---

Review the component in @src/components/Button.tsx.
Check for performance issues and suggest improvements.
```

The file content gets included in the prompt automatically.

---

## [Options](#options)

Let’s look at the configuration options in detail.

---

### [Template](#template)

The `template` option defines the prompt that will be sent to the LLM when the command is executed.

// opencode.json
```json
{
  "command": {
    "test": {
      "template": "Run the full test suite with coverage report and show any failures.\nFocus on the failing tests and suggest fixes."
    }
  }
}
```

This is a **required** config option.

---

### [Description](#description)

Use the `description` option to provide a brief description of what the command does.

// opencode.json
```json
{
  "command": {
    "test": {
      "description": "Run tests with coverage"
    }
  }
}
```

This is shown as the description in the TUI when you type in the command.

---

### [Agent](#agent)

Use the `agent` config to optionally specify which [agent](/docs/agents) should execute this command. If this is a [subagent](/docs/agents/#subagents) the command will trigger a subagent invocation by default. To disable this behavior, set `subtask` to `false`.

// opencode.json
```json
{
  "command": {
    "review": {
      "agent": "plan"
    }
  }
}
```

This is an **optional** config option. If not specified, defaults to your current agent.

---

### [Subtask](#subtask)

Use the `subtask` boolean to force the command to trigger a [subagent](/docs/agents/#subagents) invocation. This is useful if you want the command to not pollute your primary context and will **force** the agent to act as a subagent, even if `mode` is set to `primary` on the [agent](/docs/agents) configuration.

// opencode.json
```json
{
  "command": {
    "analyze": {
      "subtask": true
    }
  }
}
```

This is an **optional** config option.

---

### [Model](#model)

Use the `model` config to override the default model for this command.

// opencode.json
```json
{
  "command": {
    "analyze": {
      "model": "anthropic/claude-3-5-sonnet-20241022"
    }
  }
}
```

This is an **optional** config option.

---

## [Built-in](#built-in)

opencode includes several built-in commands like `/init`, `/undo`, `/redo`, `/share`, `/help`; [learn more](/docs/tui#commands).

> **Note:** Custom commands can override built-in commands.

If you define a custom command with the same name, it will override the built-in command.


---
# File: config.md
---
title: "Config"
source: "https://opencode.ai/docs/config/"
description: "Using the OpenCode JSON config."
---

You can configure OpenCode using a JSON config file.

---

## [Format](#format)

OpenCode supports both **JSON** and **JSONC** (JSON with Comments) formats.

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5",
  "autoupdate": true,
  "server": {
    "port": 4096,
  },
}
```

---

## [Locations](#locations)

You can place your config in a couple of different locations and they have a different order of precedence.

> **Note:** Configuration files are **merged together**, not replaced.

Configuration files are merged together, not replaced. Settings from the following config locations are combined. Later configs override earlier ones only for conflicting keys. Non-conflicting settings from all configs are preserved.

For example, if your global config sets `autoupdate: true` and your project config sets `model: "anthropic/claude-sonnet-4-5"`, the final configuration will include both settings.

---

### [Precedence order](#precedence-order)

Config sources are loaded in this order (later sources override earlier ones):

- **Remote config** (from `.well-known/opencode`) - organizational defaults

- **Global config** (`~/.config/opencode/opencode.json`) - user preferences

- **Custom config** (`OPENCODE_CONFIG` env var) - custom overrides

- **Project config** (`opencode.json` in project) - project-specific settings

- **`.opencode` directories** - agents, commands, plugins

- **Inline config** (`OPENCODE_CONFIG_CONTENT` env var) - runtime overrides

This means project configs can override global defaults, and global configs can override remote organizational defaults.

> **Note:** The `.opencode` and `~/.config/opencode` directories use **plural names** for subdirectories: `agents/`, `commands/`, `modes/`, `plugins/`, `skills/`, `tools/`, and `themes/`. Singular names (e.g., `agent/`) are also supported for backwards compatibility.

---

### [Remote](#remote)

Organizations can provide default configuration via the `.well-known/opencode` endpoint. This is fetched automatically when you authenticate with a provider that supports it.

Remote config is loaded first, serving as the base layer. All other config sources (global, project) can override these defaults.

For example, if your organization provides MCP servers that are disabled by default:

// Remote config from .well-known/opencode
```json
{
  "mcp": {
    "jira": {
      "type": "remote",
      "url": "https://jira.example.com/mcp",
      "enabled": false
    }
  }
}
```

You can enable specific servers in your local config:

// opencode.json
```json
{
  "mcp": {
    "jira": {
      "type": "remote",
      "url": "https://jira.example.com/mcp",
      "enabled": true
    }
  }
}
```

---

### [Global](#global)

Place your global OpenCode config in `~/.config/opencode/opencode.json`. Use global config for user-wide server/runtime preferences like providers, models, and permissions.

For TUI-specific settings, use `~/.config/opencode/tui.json`.

Global config overrides remote organizational defaults.

---

### [Per project](#per-project)

Add `opencode.json` in your project root. Project config has the highest precedence among standard config files - it overrides both global and remote configs.

For project-specific TUI settings, add `tui.json` alongside it.

> **Tip:** Place project specific config in the root of your project.

When OpenCode starts up, it looks for a config file in the current directory or traverse up to the nearest Git directory.

This is also safe to be checked into Git and uses the same schema as the global one.

---

### [Custom path](#custom-path)

Specify a custom config file path using the `OPENCODE_CONFIG` environment variable.

```bash
export OPENCODE_CONFIG=/path/to/my/custom-config.json
opencode run "Hello world"
```

Custom config is loaded between global and project configs in the precedence order.

---

### [Custom directory](#custom-directory)

Specify a custom config directory using the `OPENCODE_CONFIG_DIR` environment variable. This directory will be searched for agents, commands, modes, and plugins just like the standard `.opencode` directory, and should follow the same structure.

```bash
export OPENCODE_CONFIG_DIR=/path/to/my/config-directory
opencode run "Hello world"
```

The custom directory is loaded after the global config and `.opencode` directories, so it **can override** their settings.

---

## [Schema](#schema)

The server/runtime config schema is defined in [**`opencode.ai/config.json`**](https://opencode.ai/config.json).

TUI config uses [**`opencode.ai/tui.json`**](https://opencode.ai/tui.json).

Your editor should be able to validate and autocomplete based on the schema.

---

### [TUI](#tui)

Use a dedicated `tui.json` (or `tui.jsonc`) file for TUI-specific settings.

// tui.json
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "scroll_speed": 3,
  "scroll_acceleration": {
    "enabled": true
  },
  "diff_style": "auto"
}
```

Use `OPENCODE_TUI_CONFIG` to point to a custom TUI config file.

Legacy `theme`, `keybinds`, and `tui` keys in `opencode.json` are deprecated and automatically migrated when possible.

[Learn more about TUI configuration here](/docs/tui#configure).

---

### [Server](#server)

You can configure server settings for the `opencode serve` and `opencode web` commands through the `server` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "server": {
    "port": 4096,
    "hostname": "0.0.0.0",
    "mdns": true,
    "mdnsDomain": "myproject.local",
    "cors": ["http://localhost:5173"]
  }
}
```

Available options:

- `port` - Port to listen on.

- `hostname` - Hostname to listen on. When `mdns` is enabled and no hostname is set, defaults to `0.0.0.0`.

- `mdns` - Enable mDNS service discovery. This allows other devices on the network to discover your OpenCode server.

- `mdnsDomain` - Custom domain name for mDNS service. Defaults to `opencode.local`. Useful for running multiple instances on the same network.

- `cors` - Additional origins to allow for CORS when using the HTTP server from a browser-based client. Values must be full origins (scheme + host + optional port), eg `https://app.example.com`.

[Learn more about the server here](/docs/server).

---

### [Tools](#tools)

You can manage the tools an LLM can use through the `tools` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "tools": {
    "write": false,
    "bash": false
  }
}
```

[Learn more about tools here](/docs/tools).

---

### [Models](#models)

You can configure the providers and models you want to use in your OpenCode config through the `provider`, `model` and `small_model` options.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {},
  "model": "anthropic/claude-sonnet-4-5",
  "small_model": "anthropic/claude-haiku-4-5"
}
```

The `small_model` option configures a separate model for lightweight tasks like title generation. By default, OpenCode tries to use a cheaper model if one is available from your provider, otherwise it falls back to your main model.

Provider options can include `timeout`, `chunkTimeout`, and `setCacheKey`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "anthropic": {
      "options": {
        "timeout": 600000,
        "chunkTimeout": 30000,
        "setCacheKey": true
      }
    }
  }
}
```

- `timeout` - Request timeout in milliseconds (default: 300000). Set to `false` to disable.

- `chunkTimeout` - Timeout in milliseconds between streamed response chunks. If no chunk arrives in time, the request is aborted.

- `setCacheKey` - Ensure a cache key is always set for designated provider.

You can also configure [local models](/docs/models#local). [Learn more](/docs/models).

---

#### [Provider-Specific Options](#provider-specific-options)

Some providers support additional configuration options beyond the generic `timeout` and `apiKey` settings.

##### [Amazon Bedrock](#amazon-bedrock)

Amazon Bedrock supports AWS-specific configuration:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "amazon-bedrock": {
      "options": {
        "region": "us-east-1",
        "profile": "my-aws-profile",
        "endpoint": "https://bedrock-runtime.us-east-1.vpce-xxxxx.amazonaws.com"
      }
    }
  }
}
```

- `region` - AWS region for Bedrock (defaults to `AWS_REGION` env var or `us-east-1`)

- `profile` - AWS named profile from `~/.aws/credentials` (defaults to `AWS_PROFILE` env var)

- `endpoint` - Custom endpoint URL for VPC endpoints. This is an alias for the generic `baseURL` option using AWS-specific terminology. If both are specified, `endpoint` takes precedence.

> **Note:** Bearer tokens (`AWS_BEARER_TOKEN_BEDROCK` or `/connect`) take precedence over profile-based authentication. See [authentication precedence](/docs/providers#authentication-precedence) for details.

[Learn more about Amazon Bedrock configuration](/docs/providers#amazon-bedrock).

---

### [Themes](#themes)

Set your UI theme in `tui.json`.

// tui.json
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "theme": "tokyonight"
}
```

[Learn more here](/docs/themes).

---

### [Agents](#agents)

You can configure specialized agents for specific tasks through the `agent` option.

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "model": "anthropic/claude-sonnet-4-5",
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "tools": {
        // Disable file modification tools for review-only agent
        "write": false,
        "edit": false,
      },
    },
  },
}
```

You can also define agents using markdown files in `~/.config/opencode/agents/` or `.opencode/agents/`. [Learn more here](/docs/agents).

---

### [Default agent](#default-agent)

You can set the default agent using the `default_agent` option. This determines which agent is used when none is explicitly specified.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "plan"
}
```

The default agent must be a primary agent (not a subagent). This can be a built-in agent like `"build"` or `"plan"`, or a [custom agent](/docs/agents) you’ve defined. If the specified agent doesn’t exist or is a subagent, OpenCode will fall back to `"build"` with a warning.

This setting applies across all interfaces: TUI, CLI (`opencode run`), desktop app, and GitHub Action.

---

### [Sharing](#sharing)

You can configure the [share](/docs/share) feature through the `share` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "share": "manual"
}
```

This takes:

- `"manual"` - Allow manual sharing via commands (default)

- `"auto"` - Automatically share new conversations

- `"disabled"` - Disable sharing entirely

By default, sharing is set to manual mode where you need to explicitly share conversations using the `/share` command.

---

### [Commands](#commands)

You can configure custom commands for repetitive tasks through the `command` option.

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "command": {
    "test": {
      "template": "Run the full test suite with coverage report and show any failures.\nFocus on the failing tests and suggest fixes.",
      "description": "Run tests with coverage",
      "agent": "build",
      "model": "anthropic/claude-haiku-4-5",
    },
    "component": {
      "template": "Create a new React component named $ARGUMENTS with TypeScript support.\nInclude proper typing and basic structure.",
      "description": "Create a new component",
    },
  },
}
```

You can also define commands using markdown files in `~/.config/opencode/commands/` or `.opencode/commands/`. [Learn more here](/docs/commands).

---

### [Keybinds](#keybinds)

Customize keybinds in `tui.json`.

// tui.json
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "keybinds": {}
}
```

[Learn more here](/docs/keybinds).

---

### [Snapshot](#snapshot)

OpenCode uses snapshots to track file changes during agent operations, enabling you to undo and revert changes within a session. Snapshots are enabled by default.

For large repositories or projects with many submodules, the snapshot system can cause slow indexing and significant disk usage as it tracks all changes using an internal git repository. You can disable snapshots using the `snapshot` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "snapshot": false
}
```

Note that disabling snapshots means changes made by the agent cannot be rolled back through the UI.

---

### [Autoupdate](#autoupdate)

OpenCode will automatically download any new updates when it starts up. You can disable this with the `autoupdate` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "autoupdate": false
}
```

If you don’t want updates but want to be notified when a new version is available, set `autoupdate` to `"notify"`. Notice that this only works if it was not installed using a package manager such as Homebrew.

---

### [Formatters](#formatters)

You can configure code formatters through the `formatter` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "formatter": {
    "prettier": {
      "disabled": true
    },
    "custom-prettier": {
      "command": ["npx", "prettier", "--write", "$FILE"],
      "environment": {
        "NODE_ENV": "development"
      },
      "extensions": [".js", ".ts", ".jsx", ".tsx"]
    }
  }
}
```

[Learn more about formatters here](/docs/formatters).

---

### [Permissions](#permissions)

By default, opencode **allows all operations** without requiring explicit approval. You can change this using the `permission` option.

For example, to ensure that the `edit` and `bash` tools require user approval:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "ask",
    "bash": "ask"
  }
}
```

[Learn more about permissions here](/docs/permissions).

---

### [Compaction](#compaction)

You can control context compaction behavior through the `compaction` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "compaction": {
    "auto": true,
    "prune": true,
    "reserved": 10000
  }
}
```

- `auto` - Automatically compact the session when context is full (default: `true`).

- `prune` - Remove old tool outputs to save tokens (default: `true`).

- `reserved` - Token buffer for compaction. Leaves enough window to avoid overflow during compaction

---

### [Watcher](#watcher)

You can configure file watcher ignore patterns through the `watcher` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "watcher": {
    "ignore": ["node_modules/**", "dist/**", ".git/**"]
  }
}
```

Patterns follow glob syntax. Use this to exclude noisy directories from file watching.

---

### [MCP servers](#mcp-servers)

You can configure MCP servers you want to use through the `mcp` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {}
}
```

[Learn more here](/docs/mcp-servers).

---

### [Plugins](#plugins)

[Plugins](/docs/plugins) extend OpenCode with custom tools, hooks, and integrations.

Place plugin files in `.opencode/plugins/` or `~/.config/opencode/plugins/`. You can also load plugins from npm through the `plugin` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-helicone-session", "@my-org/custom-plugin"]
}
```

[Learn more here](/docs/plugins).

---

### [Instructions](#instructions)

You can configure the instructions for the model you’re using through the `instructions` option.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["CONTRIBUTING.md", "docs/guidelines.md", ".cursor/rules/*.md"]
}
```

This takes an array of paths and glob patterns to instruction files. [Learn more about rules here](/docs/rules).

---

### [Disabled providers](#disabled-providers)

You can disable providers that are loaded automatically through the `disabled_providers` option. This is useful when you want to prevent certain providers from being loaded even if their credentials are available.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "disabled_providers": ["openai", "gemini"]
}
```

> **Note:** The `disabled_providers` takes priority over `enabled_providers`.

The `disabled_providers` option accepts an array of provider IDs. When a provider is disabled:

- It won’t be loaded even if environment variables are set.

- It won’t be loaded even if API keys are configured through the `/connect` command.

- The provider’s models won’t appear in the model selection list.

---

### [Enabled providers](#enabled-providers)

You can specify an allowlist of providers through the `enabled_providers` option. When set, only the specified providers will be enabled and all others will be ignored.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "enabled_providers": ["anthropic", "openai"]
}
```

This is useful when you want to restrict OpenCode to only use specific providers rather than disabling them one by one.

> **Note:** The `disabled_providers` takes priority over `enabled_providers`.

If a provider appears in both `enabled_providers` and `disabled_providers`, the `disabled_providers` takes priority for backwards compatibility.

---

### [Experimental](#experimental)

The `experimental` key contains options that are under active development.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "experimental": {}
}
```

> **Caution:** Experimental options are not stable. They may change or be removed without notice.

---

## [Variables](#variables)

You can use variable substitution in your config files to reference environment variables and file contents.

---

### [Env vars](#env-vars)

Use `{env:VARIABLE_NAME}` to substitute environment variables:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "{env:OPENCODE_MODEL}",
  "provider": {
    "anthropic": {
      "models": {},
      "options": {
        "apiKey": "{env:ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

If the environment variable is not set, it will be replaced with an empty string.

---

### [Files](#files)

Use `{file:path/to/file}` to substitute the contents of a file:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["./custom-instructions.md"],
  "provider": {
    "openai": {
      "options": {
        "apiKey": "{file:~/.secrets/openai-key}"
      }
    }
  }
}
```

File paths can be:

- Relative to the config file directory

- Or absolute paths starting with `/` or `~`

These are useful for:

- Keeping sensitive data like API keys in separate files.

- Including large instruction files without cluttering your config.

- Sharing common configuration snippets across multiple config files.


---
# File: custom-tools.md
---
title: "Custom Tools"
source: "https://opencode.ai/docs/custom-tools/"
description: "Create tools the LLM can call in opencode."
---

Custom tools are functions you create that the LLM can call during conversations. They work alongside opencode’s [built-in tools](/docs/tools) like `read`, `write`, and `bash`.

---

## [Creating a tool](#creating-a-tool)

Tools are defined as **TypeScript** or **JavaScript** files. However, the tool definition can invoke scripts written in **any language** — TypeScript or JavaScript is only used for the tool definition itself.

---

### [Location](#location)

They can be defined:

- Locally by placing them in the `.opencode/tools/` directory of your project.

- Or globally, by placing them in `~/.config/opencode/tools/`.

---

### [Structure](#structure)

The easiest way to create tools is using the `tool()` helper which provides type-safety and validation.

// .opencode/tools/database.ts
```ts
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Query the project database",
  args: {
    query: tool.schema.string().describe("SQL query to execute"),
  },
  async execute(args) {
    // Your database logic here
    return `Executed query: ${args.query}`
  },
})
```

The **filename** becomes the **tool name**. The above creates a `database` tool.

---

#### [Multiple tools per file](#multiple-tools-per-file)

You can also export multiple tools from a single file. Each export becomes **a separate tool** with the name **`_`**:

// .opencode/tools/math.ts
```ts
import { tool } from "@opencode-ai/plugin"

export const add = tool({
  description: "Add two numbers",
  args: {
    a: tool.schema.number().describe("First number"),
    b: tool.schema.number().describe("Second number"),
  },
  async execute(args) {
    return args.a + args.b
  },
})

export const multiply = tool({
  description: "Multiply two numbers",
  args: {
    a: tool.schema.number().describe("First number"),
    b: tool.schema.number().describe("Second number"),
  },
  async execute(args) {
    return args.a * args.b
  },
})
```

This creates two tools: `math_add` and `math_multiply`.

---

#### [Name collisions with built-in tools](#name-collisions-with-built-in-tools)

Custom tools are keyed by tool name. If a custom tool uses the same name as a built-in tool, the custom tool takes precedence.

For example, this file replaces the built-in `bash` tool:

// .opencode/tools/bash.ts
```ts
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Restricted bash wrapper",
  args: {
    command: tool.schema.string(),
  },
  async execute(args) {
    return `blocked: ${args.command}`
  },
})
```

> **Note:** Prefer unique names unless you intentionally want to replace a built-in tool. If you want to disable a built in tool but not override it, use [permissions](/docs/permissions).

---

### [Arguments](#arguments)

You can use `tool.schema`, which is just [Zod](https://zod.dev), to define argument types.

```ts
args: {
  query: tool.schema.string().describe("SQL query to execute")
}
```

You can also import [Zod](https://zod.dev) directly and return a plain object:

```ts
import { z } from "zod"

export default {
  description: "Tool description",
  args: {
    param: z.string().describe("Parameter description"),
  },
  async execute(args, context) {
    // Tool implementation
    return "result"
  },
}
```

---

### [Context](#context)

Tools receive context about the current session:

// .opencode/tools/project.ts
```ts
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Get project information",
  args: {},
  async execute(args, context) {
    // Access context information
    const { agent, sessionID, messageID, directory, worktree } = context
    return `Agent: ${agent}, Session: ${sessionID}, Message: ${messageID}, Directory: ${directory}, Worktree: ${worktree}`
  },
})
```

Use `context.directory` for the session working directory. Use `context.worktree` for the git worktree root.

---

## [Examples](#examples)

### [Write a tool in Python](#write-a-tool-in-python)

You can write your tools in any language you want. Here’s an example that adds two numbers using Python.

First, create the tool as a Python script:

// .opencode/tools/add.py
```python
import sys

a = int(sys.argv[1])
b = int(sys.argv[2])
print(a + b)
```

Then create the tool definition that invokes it:

// .opencode/tools/python-add.ts
```ts
import { tool } from "@opencode-ai/plugin"
import path from "path"

export default tool({
  description: "Add two numbers using Python",
  args: {
    a: tool.schema.number().describe("First number"),
    b: tool.schema.number().describe("Second number"),
  },
  async execute(args, context) {
    const script = path.join(context.worktree, ".opencode/tools/add.py")
    const result = await Bun.$`python3 ${script} ${args.a} ${args.b}`.text()
    return result.trim()
  },
})
```

Here we are using the [`Bun.$`](https://bun.com/docs/runtime/shell) utility to run the Python script.


---
# File: ecosystem.md
---
title: "Ecosystem"
source: "https://opencode.ai/docs/ecosystem/"
description: "Projects and integrations built with OpenCode."
---

A collection of community projects built on OpenCode.

> **Note:** Want to add your OpenCode related project to this list? Submit a PR.

You can also check out [awesome-opencode](https://github.com/awesome-opencode/awesome-opencode) and [opencode.cafe](https://opencode.cafe), a community that aggregates the ecosystem and community.

---

## [Plugins](#plugins)

NameDescriptionopencode-daytonaAutomatically run OpenCode sessions in isolated Daytona sandboxes with git sync and live previewsopencode-helicone-sessionAutomatically inject Helicone session headers for request groupingopencode-type-injectAuto-inject TypeScript/Svelte types into file reads with lookup toolsopencode-openai-codex-authUse your ChatGPT Plus/Pro subscription instead of API creditsopencode-gemini-authUse your existing Gemini plan instead of API billingopencode-antigravity-authUse Antigravity’s free models instead of API billingopencode-devcontainersMulti-branch devcontainer isolation with shallow clones and auto-assigned portsopencode-google-antigravity-authGoogle Antigravity OAuth Plugin, with support for Google Search, and more robust API handlingopencode-dynamic-context-pruningOptimize token usage by pruning obsolete tool outputsopencode-vibeguardRedact secrets/PII into VibeGuard-style placeholders before LLM calls; restore locallyopencode-websearch-citedAdd native websearch support for supported providers with Google grounded styleopencode-ptyEnables AI agents to run background processes in a PTY, send interactive input to them.opencode-shell-strategyInstructions for non-interactive shell commands - prevents hangs from TTY-dependent operationsopencode-wakatimeTrack OpenCode usage with Wakatimeopencode-md-table-formatterClean up markdown tables produced by LLMsopencode-morph-pluginFast Apply editing, WarpGrep codebase search, and context compaction via Morphoh-my-opencodeBackground agents, pre-built LSP/AST/MCP tools, curated agents, Claude Code compatibleopencode-notificatorDesktop notifications and sound alerts for OpenCode sessionsopencode-notifierDesktop notifications and sound alerts for permission, completion, and error eventsopencode-zellij-namerAI-powered automatic Zellij session naming based on OpenCode contextopencode-skillfulAllow OpenCode agents to lazy load prompts on demand with skill discovery and injectionopencode-supermemoryPersistent memory across sessions using Supermemory@plannotator/opencodeInteractive plan review with visual annotation and private/offline sharing@openspoon/subtask2Extend opencode /commands into a powerful orchestration system with granular flow controlopencode-schedulerSchedule recurring jobs using launchd (Mac) or systemd (Linux) with cron syntaxmicodeStructured Brainstorm → Plan → Implement workflow with session continuityocttoInteractive browser UI for AI brainstorming with multi-question formsopencode-background-agentsClaude Code-style background agents with async delegation and context persistenceopencode-notifyNative OS notifications for OpenCode – know when tasks completeopencode-workspaceBundled multi-agent orchestration harness – 16 components, one installopencode-worktreeZero-friction git worktrees for OpenCodeopencode-sentry-monitorTrace and debug your AI agents with Sentry AI Monitoringopencode-firecrawlWeb scraping, crawling, and search via the Firecrawl CLI

---

## [Projects](#projects)

NameDescriptionkimakiDiscord bot to control OpenCode sessions, built on the SDKopencode.nvimNeovim plugin for editor-aware prompts, built on the APIportalMobile-first web UI for OpenCode over Tailscale/VPNopencode plugin templateTemplate for building OpenCode pluginsopencode.nvimNeovim frontend for opencode - a terminal-based AI coding agentai-sdk-provider-opencode-sdkVercel AI SDK provider for using OpenCode via @opencode-ai/sdkOpenChamberWeb / Desktop App and VS Code Extension for OpenCodeOpenCode-ObsidianObsidian plugin that embeds OpenCode in Obsidian’s UIOpenWorkAn open-source alternative to Claude Cowork, powered by OpenCodeocxOpenCode extension manager with portable, isolated profiles.CodeNomadDesktop, Web, Mobile and Remote Client App for OpenCode

---

## [Agents](#agents)

NameDescriptionAgenticModular AI agents and commands for structured developmentopencode-agentsConfigs, prompts, agents, and plugins for enhanced workflows


---
# File: enterprise.md
---
title: "Enterprise"
source: "https://opencode.ai/docs/enterprise/"
description: "Using OpenCode securely in your organization."
---

OpenCode Enterprise is for organizations that want to ensure that their code and data never leaves their infrastructure. It can do this by using a centralized config that integrates with your SSO and internal AI gateway.

> **Note:** OpenCode does not store any of your code or context data.

To get started with OpenCode Enterprise:

- Do a trial internally with your team.

- **[Contact us](mailto:contact@anoma.ly)** to discuss pricing and implementation options.

---

## [Trial](#trial)

OpenCode is open source and does not store any of your code or context data, so your developers can simply [get started](/docs/) and carry out a trial.

---

### [Data handling](#data-handling)

**OpenCode does not store your code or context data.** All processing happens locally or through direct API calls to your AI provider.

This means that as long as you are using a provider you trust, or an internal AI gateway, you can use OpenCode securely.

The only caveat here is the optional `/share` feature.

---

#### [Sharing conversations](#sharing-conversations)

If a user enables the `/share` feature, the conversation and the data associated with it are sent to the service we use to host these share pages at opencode.ai.

The data is currently served through our CDN’s edge network, and is cached on the edge near your users.

We recommend you disable this for your trial.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "share": "disabled"
}
```

[Learn more about sharing](/docs/share).

---

### [Code ownership](#code-ownership)

**You own all code produced by OpenCode.** There are no licensing restrictions or ownership claims.

---

## [Pricing](#pricing)

We use a per-seat model for OpenCode Enterprise. If you have your own LLM gateway, we do not charge for tokens used. For further details about pricing and implementation options, **[contact us](mailto:contact@anoma.ly)**.

---

## [Deployment](#deployment)

Once you have completed your trial and you are ready to use OpenCode at your organization, you can **[contact us](mailto:contact@anoma.ly)** to discuss pricing and implementation options.

---

### [Central Config](#central-config)

We can set up OpenCode to use a single central config for your entire organization.

This centralized config can integrate with your SSO provider and ensures all users access only your internal AI gateway.

---

### [SSO integration](#sso-integration)

Through the central config, OpenCode can integrate with your organization’s SSO provider for authentication.

This allows OpenCode to obtain credentials for your internal AI gateway through your existing identity management system.

---

### [Internal AI gateway](#internal-ai-gateway)

With the central config, OpenCode can also be configured to use only your internal AI gateway.

You can also disable all other AI providers, ensuring all requests go through your organization’s approved infrastructure.

---

### [Self-hosting](#self-hosting)

While we recommend disabling the share pages to ensure your data never leaves your organization, we can also help you self-host them on your infrastructure.

This is currently on our roadmap. If you’re interested, **[let us know](mailto:contact@anoma.ly)**.

---

## [FAQ](#faq)

What is OpenCode Enterprise?

OpenCode Enterprise is for organizations that want to ensure that their code and data never leaves their infrastructure. It can do this by using a centralized config that integrates with your SSO and internal AI gateway.

How do I get started with OpenCode Enterprise?

Simply start with an internal trial with your team. OpenCode by default does not store your code or context data, making it easy to get started.

Then **[contact us](mailto:contact@anoma.ly)** to discuss pricing and implementation options.

How does enterprise pricing work?

We offer per-seat enterprise pricing. If you have your own LLM gateway, we do not charge for tokens used. For further details, **[contact us](mailto:contact@anoma.ly)** for a custom quote based on your organization’s needs.

Is my data secure with OpenCode Enterprise?

Yes. OpenCode does not store your code or context data. All processing happens locally or through direct API calls to your AI provider. With central config and SSO integration, your data remains secure within your organization’s infrastructure.

Can we use our own private NPM registry?

OpenCode supports private npm registries through Bun’s native `.npmrc` file support. If your organization uses a private registry, such as JFrog Artifactory, Nexus, or similar, ensure developers are authenticated before running OpenCode.

To set up authentication with your private registry:

```bash
npm login --registry=https://your-company.jfrog.io/api/npm/npm-virtual/
```

This creates `~/.npmrc` with authentication details. OpenCode will automatically pick this up.

> **Caution:** You must be logged into the private registry before running OpenCode.

Alternatively, you can manually configure a `.npmrc` file:

// ~/.npmrc
```bash
registry=https://your-company.jfrog.io/api/npm/npm-virtual/
//your-company.jfrog.io/api/npm/npm-virtual/:_authToken=${NPM_AUTH_TOKEN}
```

Developers must be logged into the private registry before running OpenCode to ensure packages can be installed from your enterprise registry.


---
# File: favicon-v3.svg.md
---
title: "Untitled"
---




---
# File: formatters.md
---
title: "Formatters"
source: "https://opencode.ai/docs/formatters/"
description: "OpenCode uses language specific formatters."
---

OpenCode automatically formats files after they are written or edited using language-specific formatters. This ensures that the code that is generated follows the code styles of your project.

---

## [Built-in](#built-in)

OpenCode comes with several built-in formatters for popular languages and frameworks. Below is a list of the formatters, supported file extensions, and commands or config options it needs.

FormatterExtensionsRequirementsair.Rair command availablebiome.js, .jsx, .ts, .tsx, .html, .css, .md, .json, .yaml, and morebiome.json(c) config filecargofmt.rscargo fmt command availableclang-format.c, .cpp, .h, .hpp, .ino, and more.clang-format config filecljfmt.clj, .cljs, .cljc, .edncljfmt command availabledart.dartdart command availabledfmt.ddfmt command availablegleam.gleamgleam command availablegofmt.gogofmt command availablehtmlbeautifier.erb, .html.erbhtmlbeautifier command availablektlint.kt, .ktsktlint command availablemix.ex, .exs, .eex, .heex, .leex, .neex, .sfacemix command availablenixfmt.nixnixfmt command availableocamlformat.ml, .mliocamlformat command available and .ocamlformat config fileormolu.hsormolu command availableoxfmt (Experimental).js, .jsx, .ts, .tsxoxfmt dependency in package.json and an experimental env variable flagpint.phplaravel/pint dependency in composer.jsonprettier.js, .jsx, .ts, .tsx, .html, .css, .md, .json, .yaml, and moreprettier dependency in package.jsonrubocop.rb, .rake, .gemspec, .rurubocop command availableruff.py, .pyiruff command available with configrustfmt.rsrustfmt command availableshfmt.sh, .bashshfmt command availablestandardrb.rb, .rake, .gemspec, .rustandardrb command availableterraform.tf, .tfvarsterraform command availableuv.py, .pyiuv command availablezig.zig, .zonzig command available

So if your project has `prettier` in your `package.json`, OpenCode will automatically use it.

---

## [How it works](#how-it-works)

When OpenCode writes or edits a file, it:

- Checks the file extension against all enabled formatters.

- Runs the appropriate formatter command on the file.

- Applies the formatting changes automatically.

This process happens in the background, ensuring your code styles are maintained without any manual steps.

---

## [Configure](#configure)

You can customize formatters through the `formatter` section in your OpenCode config.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "formatter": {}
}
```

Each formatter configuration supports the following:

PropertyTypeDescriptiondisabledbooleanSet this to true to disable the formattercommandstring[]The command to run for formattingenvironmentobjectEnvironment variables to set when running the formatterextensionsstring[]File extensions this formatter should handle

Let’s look at some examples.

---

### [Disabling formatters](#disabling-formatters)

To disable **all** formatters globally, set `formatter` to `false`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "formatter": false
}
```

To disable a **specific** formatter, set `disabled` to `true`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "formatter": {
    "prettier": {
      "disabled": true
    }
  }
}
```

---

### [Custom formatters](#custom-formatters)

You can override the built-in formatters or add new ones by specifying the command, environment variables, and file extensions:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "formatter": {
    "prettier": {
      "command": ["npx", "prettier", "--write", "$FILE"],
      "environment": {
        "NODE_ENV": "development"
      },
      "extensions": [".js", ".ts", ".jsx", ".tsx"]
    },
    "custom-markdown-formatter": {
      "command": ["deno", "fmt", "$FILE"],
      "extensions": [".md"]
    }
  }
}
```

The **`$FILE` placeholder** in the command will be replaced with the path to the file being formatted.


---
# File: github.md
---
title: "GitHub"
source: "https://opencode.ai/docs/github/"
description: "Use OpenCode in GitHub issues and pull-requests."
---

OpenCode integrates with your GitHub workflow. Mention `/opencode` or `/oc` in your comment, and OpenCode will execute tasks within your GitHub Actions runner.

---

## [Features](#features)

- **Triage issues**: Ask OpenCode to look into an issue and explain it to you.

- **Fix and implement**: Ask OpenCode to fix an issue or implement a feature. And it will work in a new branch and submits a PR with all the changes.

- **Secure**: OpenCode runs inside your GitHub’s runners.

---

## [Installation](#installation)

Run the following command in a project that is in a GitHub repo:

```bash
opencode github install
```

This will walk you through installing the GitHub app, creating the workflow, and setting up secrets.

---

### [Manual Setup](#manual-setup)

Or you can set it up manually.

- **Install the GitHub app** Head over to [**github.com/apps/opencode-agent**](https://github.com/apps/opencode-agent). Make sure it’s installed on the target repository.

- **Add the workflow** Add the following workflow file to `.github/workflows/opencode.yml` in your repo. Make sure to set the appropriate `model` and required API keys in `env`. // .github/workflows/opencode.yml ```yml name: opencode on: issue_comment: types: [created] pull_request_review_comment: types: [created] jobs: opencode: if: | contains(github.event.comment.body, '/oc') || contains(github.event.comment.body, '/opencode') runs-on: ubuntu-latest permissions: id-token: write steps: - name: Checkout repository uses: actions/checkout@v6 with: fetch-depth: 1 persist-credentials: false - name: Run OpenCode uses: anomalyco/opencode/github@latest env: ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }} with: model: anthropic/claude-sonnet-4-20250514 # share: true # github_token: xxxx ```

- **Store the API keys in secrets** In your organization or project **settings**, expand **Secrets and variables** on the left and select **Actions**. And add the required API keys.

---

## [Configuration](#configuration)

- `model`: The model to use with OpenCode. Takes the format of `provider/model`. This is **required**.

- `agent`: The agent to use. Must be a primary agent. Falls back to `default_agent` from config or `"build"` if not found.

- `share`: Whether to share the OpenCode session. Defaults to **true** for public repositories.

- `prompt`: Optional custom prompt to override the default behavior. Use this to customize how OpenCode processes requests.

- `token`: Optional GitHub access token for performing operations such as creating comments, committing changes, and opening pull requests. By default, OpenCode uses the installation access token from the OpenCode GitHub App, so commits, comments, and pull requests appear as coming from the app. Alternatively, you can use the GitHub Action runner’s [built-in `GITHUB_TOKEN`](https://docs.github.com/en/actions/tutorials/authenticate-with-github_token) without installing the OpenCode GitHub App. Just make sure to grant the required permissions in your workflow: ```yaml permissions: id-token: write contents: write pull-requests: write issues: write ``` You can also use a [personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)(PAT) if preferred.

---

## [Supported Events](#supported-events)

OpenCode can be triggered by the following GitHub events:

Event TypeTriggered ByDetailsissue_commentComment on an issue or PRMention /opencode or /oc in your comment. OpenCode reads context and can create branches, open PRs, or reply.pull_request_review_commentComment on specific code lines in a PRMention /opencode or /oc while reviewing code. OpenCode receives file path, line numbers, and diff context.issuesIssue opened or editedAutomatically trigger OpenCode when issues are created or modified. Requires prompt input.pull_requestPR opened or updatedAutomatically trigger OpenCode when PRs are opened, synchronized, or reopened. Useful for automated reviews.scheduleCron-based scheduleRun OpenCode on a schedule. Requires prompt input. Output goes to logs and PRs (no issue to comment on).workflow_dispatchManual trigger from GitHub UITrigger OpenCode on demand via Actions tab. Requires prompt input. Output goes to logs and PRs.

### [Schedule Example](#schedule-example)

Run OpenCode on a schedule to perform automated tasks:

// .github/workflows/opencode-scheduled.yml
```yaml
name: Scheduled OpenCode Task

on:
  schedule:
    - cron: "0 9 * * 1" # Every Monday at 9am UTC

jobs:
  opencode:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: write
      pull-requests: write
      issues: write
    steps:
      - name: Checkout repository
        uses: actions/checkout@v6
        with:
          persist-credentials: false

      - name: Run OpenCode
        uses: anomalyco/opencode/github@latest
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        with:
          model: anthropic/claude-sonnet-4-20250514
          prompt: |
            Review the codebase for any TODO comments and create a summary.
            If you find issues worth addressing, open an issue to track them.
```

For scheduled events, the `prompt` input is **required** since there’s no comment to extract instructions from. Scheduled workflows run without a user context to permission-check, so the workflow must grant `contents: write` and `pull-requests: write` if you expect OpenCode to create branches or PRs.

---

### [Pull Request Example](#pull-request-example)

Automatically review PRs when they are opened or updated:

// .github/workflows/opencode-review.yml
```yaml
name: opencode-review

on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]

jobs:
  review:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
      pull-requests: read
      issues: read
    steps:
      - uses: actions/checkout@v6
        with:
          persist-credentials: false
      - uses: anomalyco/opencode/github@latest
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          model: anthropic/claude-sonnet-4-20250514
          use_github_token: true
          prompt: |
            Review this pull request:
            - Check for code quality issues
            - Look for potential bugs
            - Suggest improvements
```

For `pull_request` events, if no `prompt` is provided, OpenCode defaults to reviewing the pull request.

---

### [Issues Triage Example](#issues-triage-example)

Automatically triage new issues. This example filters to accounts older than 30 days to reduce spam:

// .github/workflows/opencode-triage.yml
```yaml
name: Issue Triage

on:
  issues:
    types: [opened]

jobs:
  triage:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: write
      pull-requests: write
      issues: write
    steps:
      - name: Check account age
        id: check
        uses: actions/github-script@v7
        with:
          script: |
            const user = await github.rest.users.getByUsername({
              username: context.payload.issue.user.login
            });
            const created = new Date(user.data.created_at);
            const days = (Date.now() - created) / (1000 * 60 * 60 * 24);
            return days >= 30;
          result-encoding: string

      - uses: actions/checkout@v6
        if: steps.check.outputs.result == 'true'
        with:
          persist-credentials: false

      - uses: anomalyco/opencode/github@latest
        if: steps.check.outputs.result == 'true'
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        with:
          model: anthropic/claude-sonnet-4-20250514
          prompt: |
            Review this issue. If there's a clear fix or relevant docs:
            - Provide documentation links
            - Add error handling guidance for code examples
            Otherwise, do not comment.
```

For `issues` events, the `prompt` input is **required** since there’s no comment to extract instructions from.

---

## [Custom prompts](#custom-prompts)

Override the default prompt to customize OpenCode’s behavior for your workflow.

// .github/workflows/opencode.yml
```yaml
- uses: anomalyco/opencode/github@latest
  with:
    model: anthropic/claude-sonnet-4-5
    prompt: |
      Review this pull request:
      - Check for code quality issues
      - Look for potential bugs
      - Suggest improvements
```

This is useful for enforcing specific review criteria, coding standards, or focus areas relevant to your project.

---

## [Examples](#examples)

Here are some examples of how you can use OpenCode in GitHub.

- **Explain an issue** Add this comment in a GitHub issue. ```plaintext /opencode explain this issue ``` OpenCode will read the entire thread, including all comments, and reply with a clear explanation.

- **Fix an issue** In a GitHub issue, say: ```plaintext /opencode fix this ``` And OpenCode will create a new branch, implement the changes, and open a PR with the changes.

- **Review PRs and make changes** Leave the following comment on a GitHub PR. ```plaintext Delete the attachment from S3 when the note is removed /oc ``` OpenCode will implement the requested change and commit it to the same PR.

- **Review specific code lines** Leave a comment directly on code lines in the PR’s “Files” tab. OpenCode automatically detects the file, line numbers, and diff context to provide precise responses. ```plaintext [Comment on specific lines in Files tab] /oc add error handling here ``` When commenting on specific lines, OpenCode receives: The exact file being reviewed

- The specific lines of code

- The surrounding diff context

- Line number information

This allows for more targeted requests without needing to specify file paths or line numbers manually.


---
# File: gitlab.md
---
title: "GitLab"
source: "https://opencode.ai/docs/gitlab/"
description: "Use OpenCode in GitLab issues and merge requests."
---

OpenCode integrates with your GitLab workflow through your GitLab CI/CD pipeline or with GitLab Duo.

In both cases, OpenCode will run on your GitLab runners.

---

## [GitLab CI](#gitlab-ci)

OpenCode works in a regular GitLab pipeline. You can build it into a pipeline as a [CI component](https://docs.gitlab.com/ee/ci/components/)

Here we are using a community-created CI/CD component for OpenCode — [nagyv/gitlab-opencode](https://gitlab.com/nagyv/gitlab-opencode).

---

### [Features](#features)

- **Use custom configuration per job**: Configure OpenCode with a custom configuration directory, for example `./config/#custom-directory` to enable or disable functionality per OpenCode invocation.

- **Minimal setup**: The CI component sets up OpenCode in the background, you only need to create the OpenCode configuration and the initial prompt.

- **Flexible**: The CI component supports several inputs for customizing its behavior

---

### [Setup](#setup)

- Store your OpenCode authentication JSON as a File type CI environment variables under **Settings** > **CI/CD** > **Variables**. Make sure to mark them as “Masked and hidden”.

- Add the following to your `.gitlab-ci.yml` file. // .gitlab-ci.yml ```yaml include: - component: $CI_SERVER_FQDN/nagyv/gitlab-opencode/opencode@2 inputs: config_dir: ${CI_PROJECT_DIR}/opencode-config auth_json: $OPENCODE_AUTH_JSON # The variable name for your OpenCode authentication JSON command: optional-custom-command message: "Your prompt here" ```

For more inputs and use cases [check out the docs](https://gitlab.com/explore/catalog/nagyv/gitlab-opencode) for this component.

---

## [GitLab Duo](#gitlab-duo)

OpenCode integrates with your GitLab workflow. Mention `@opencode` in a comment, and OpenCode will execute tasks within your GitLab CI pipeline.

---

### [Features](#features-1)

- **Triage issues**: Ask OpenCode to look into an issue and explain it to you.

- **Fix and implement**: Ask OpenCode to fix an issue or implement a feature. It will create a new branch and raise a merge request with the changes.

- **Secure**: OpenCode runs on your GitLab runners.

---

### [Setup](#setup-1)

OpenCode runs in your GitLab CI/CD pipeline, here’s what you’ll need to set it up:

> **Tip:** Check out the [**GitLab docs**](https://docs.gitlab.com/user/duo_agent_platform/agent_assistant/) for up to date instructions.

- Configure your GitLab environment

- Set up CI/CD

- Get an AI model provider API key

- Create a service account

- Configure CI/CD variables

- Create a flow config file, here’s an example: Flow configuration ```yaml image: node:22-slim commands: - echo "Installing opencode" - npm install --global opencode-ai - echo "Installing glab" - export GITLAB_TOKEN=$GITLAB_TOKEN_OPENCODE - apt-get update --quiet && apt-get install --yes curl wget gpg git && rm --recursive --force /var/lib/apt/lists/* - curl --silent --show-error --location "https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository" | bash - apt-get install --yes glab - echo "Configuring glab" - echo $GITLAB_HOST - echo "Creating OpenCode auth configuration" - mkdir --parents ~/.local/share/opencode - | cat > ~/.local/share/opencode/auth.json Please use the glab CLI to access data from GitLab. The glab CLI has already been authenticated. You can run the corresponding commands. If you are asked to summarize an MR or issue or asked to provide more information then please post back a note to the MR/Issue so that the user can see it. You don't need to commit or push up changes, those will be done automatically based on the file changes you make. " - git checkout --branch $CI_WORKLOAD_REF origin/$CI_WORKLOAD_REF - echo "Checking for git changes and pushing if any exist" - | if ! git diff --quiet || ! git diff --cached --quiet || [ --not --zero "$(git ls-files --others --exclude-standard)" ]; then echo "Git changes detected, adding and pushing..." git add . if git diff --cached --quiet; then echo "No staged changes to commit" else echo "Committing changes to branch: $CI_WORKLOAD_REF" git commit --message "Codex changes" echo "Pushing changes up to $CI_WORKLOAD_REF" git push https://gitlab-ci-token:$GITLAB_TOKEN@$GITLAB_HOST/gl-demo-ultimate-dev-ai-epic-17570/test-java-project.git $CI_WORKLOAD_REF echo "Changes successfully pushed" fi else echo "No git changes detected, skipping push" fi variables: - ANTHROPIC_API_KEY - GITLAB_TOKEN_OPENCODE - GITLAB_HOST ```

You can refer to the [GitLab CLI agents docs](https://docs.gitlab.com/user/duo_agent_platform/agent_assistant/) for detailed instructions.

---

### [Examples](#examples)

Here are some examples of how you can use OpenCode in GitLab.

> **Tip:** You can configure to use a different trigger phrase than `@opencode`.

- **Explain an issue** Add this comment in a GitLab issue. ```plaintext @opencode explain this issue ``` OpenCode will read the issue and reply with a clear explanation.

- **Fix an issue** In a GitLab issue, say: ```plaintext @opencode fix this ``` OpenCode will create a new branch, implement the changes, and open a merge request with the changes.

- **Review merge requests** Leave the following comment on a GitLab merge request. ```plaintext @opencode review this merge request ``` OpenCode will review the merge request and provide feedback.


---
# File: go.md
---
title: "Go"
source: "https://opencode.ai/docs/go/"
description: "Low cost subscription for open coding models."
---

OpenCode Go is a low cost subscription — **$5 for your first month**, then **$10/month** — that gives you reliable access to popular open coding models.

> **Note:** OpenCode Go is currently in beta.

Go works like any other provider in OpenCode. You subscribe to OpenCode Go and get your API key. It’s **completely optional** and you don’t need to use it to use OpenCode.

It is designed primarily for international users, with models hosted in the US, EU, and Singapore for stable global access.

---

## [Background](#background)

Open models have gotten really good. They now reach performance close to proprietary models for coding tasks. And because many providers can serve them competitively, they are usually far cheaper.

However, getting reliable, low latency access to them can be difficult. Providers vary in quality and availability.

> **Tip:** We tested a select group of models and providers that work well with OpenCode.

To fix this, we did a couple of things:

- We tested a select group of open models and talked to their teams about how to best run them.

- We then worked with a few providers to make sure these were being served correctly.

- Finally, we benchmarked the combination of the model/provider and came up with a list that we feel good recommending.

OpenCode Go gives you access to these models for **$5 for your first month**, then **$10/month**.

---

## [How it works](#how-it-works)

OpenCode Go works like any other provider in OpenCode.

- You sign in to **[OpenCode Zen](https://opencode.ai/auth)**, subscribe to Go, and copy your API key.

- You run the `/connect` command in the TUI, select `OpenCode Go`, and paste your API key.

- Run `/models` in the TUI to see the list of models available through Go.

> **Note:** Only one member per workspace can subscribe to OpenCode Go.

The current list of models includes:

- **GLM-5**

- **Kimi K2.5**

- **MiniMax M2.5**

- **MiniMax M2.7**

The list of models may change as we test and add new ones.

---

## [Usage limits](#usage-limits)

OpenCode Go includes the following limits:

- **5 hour limit** — $12 of usage

- **Weekly limit** — $30 of usage

- **Monthly limit** — $60 of usage

Limits are defined in dollar value. This means your actual request count depends on the model you use. Cheaper models like MiniMax M2.5 allow for more requests, while higher-cost models like GLM-5 allow for fewer.

The table below provides an estimated request count based on typical Go usage patterns:

GLM-5Kimi K2.5MiniMax M2.7MiniMax M2.5requests per 5 hour1,1501,85014,00020,000requests per week2,8804,63035,00050,000requests per month5,7509,25070,000100,000

Estimates are based on observed average request patterns:

- GLM-5 — 700 input, 52,000 cached, 150 output tokens per request

- Kimi K2.5 — 870 input, 55,000 cached, 200 output tokens per request

- MiniMax M2.7/M2.5 — 300 input, 55,000 cached, 125 output tokens per request

You can track your current usage in the **[console](https://opencode.ai/auth)**.

> **Tip:** If you reach the usage limit, you can continue using the free models.

Usage limits may change as we learn from early usage and feedback.

---

### [Usage beyond limits](#usage-beyond-limits)

If you also have credits on your Zen balance, you can enable the **Use balance** option in the console. When enabled, Go will fall back to your Zen balance after you’ve reached your usage limits instead of blocking requests.

---

## [Endpoints](#endpoints)

You can also access Go models through the following API endpoints.

ModelModel IDEndpointAI SDK PackageGLM-5glm-5https://opencode.ai/zen/go/v1/chat/completions@ai-sdk/openai-compatibleKimi K2.5kimi-k2.5https://opencode.ai/zen/go/v1/chat/completions@ai-sdk/openai-compatibleMiniMax M2.7minimax-m2.7https://opencode.ai/zen/go/v1/messages@ai-sdk/anthropicMiniMax M2.5minimax-m2.5https://opencode.ai/zen/go/v1/messages@ai-sdk/anthropic

The [model id](/docs/config/#models) in your OpenCode config uses the format `opencode-go/`. For example, for Kimi K2.5, you would use `opencode-go/kimi-k2.5` in your config.

---

## [Privacy](#privacy)

The plan is designed primarily for international users, with models hosted in the US, EU, and Singapore for stable global access. Our providers follow a zero-retention policy and do not use your data for model training.

---

## [Goals](#goals)

We created OpenCode Go to:

- Make AI coding **accessible** to more people with a low cost subscription.

- Provide **reliable** access to the best open coding models.

- Curate models that are **tested and benchmarked** for coding agent use.

- Have **no lock-in** by allowing you to use any other provider with OpenCode as well.


---
# File: ide.md
---
title: "IDE"
source: "https://opencode.ai/docs/ide/"
description: "The OpenCode extension for VS Code, Cursor, and other IDEs"
---

OpenCode integrates with VS Code, Cursor, or any IDE that supports a terminal. Just run `opencode` in the terminal to get started.

---

## [Usage](#usage)

- **Quick Launch**: Use `Cmd+Esc` (Mac) or `Ctrl+Esc` (Windows/Linux) to open OpenCode in a split terminal view, or focus an existing terminal session if one is already running.

- **New Session**: Use `Cmd+Shift+Esc` (Mac) or `Ctrl+Shift+Esc` (Windows/Linux) to start a new OpenCode terminal session, even if one is already open. You can also click the OpenCode button in the UI.

- **Context Awareness**: Automatically share your current selection or tab with OpenCode.

- **File Reference Shortcuts**: Use `Cmd+Option+K` (Mac) or `Alt+Ctrl+K` (Linux/Windows) to insert file references. For example, `@File#L37-42`.

---

## [Installation](#installation)

To install OpenCode on VS Code and popular forks like Cursor, Windsurf, VSCodium:

- Open VS Code

- Open the integrated terminal

- Run `opencode` - the extension installs automatically

If on the other hand you want to use your own IDE when you run `/editor` or `/export` from the TUI, you’ll need to set `export EDITOR="code --wait"`. [Learn more](/docs/tui/#editor-setup).

---

### [Manual Install](#manual-install)

Search for **OpenCode** in the Extension Marketplace and click **Install**.

---

### [Troubleshooting](#troubleshooting)

If the extension fails to install automatically:

- Ensure you’re running `opencode` in the integrated terminal.

- Confirm the CLI for your IDE is installed: For VS Code: `code` command

- For Cursor: `cursor` command

- For Windsurf: `windsurf` command

- For VSCodium: `codium` command

- If not, run `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux) and search for “Shell Command: Install ‘code’ command in PATH” (or the equivalent for your IDE)

- Ensure VS Code has permission to install extensions


---
# File: keybinds.md
---
title: "Keybinds"
source: "https://opencode.ai/docs/keybinds/"
description: "Customize your keybinds."
---

OpenCode has a list of keybinds that you can customize through `tui.json`.

// tui.json
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "keybinds": {
    "leader": "ctrl+x",
    "app_exit": "ctrl+c,ctrl+d,q",
    "editor_open": "e",
    "theme_list": "t",
    "sidebar_toggle": "b",
    "scrollbar_toggle": "none",
    "username_toggle": "none",
    "status_view": "s",
    "tool_details": "none",
    "session_export": "x",
    "session_new": "n",
    "session_list": "l",
    "session_timeline": "g",
    "session_fork": "none",
    "session_rename": "none",
    "session_share": "none",
    "session_unshare": "none",
    "session_interrupt": "escape",
    "session_compact": "c",
    "session_child_first": "down",
    "session_child_cycle": "right",
    "session_child_cycle_reverse": "left",
    "session_parent": "up",
    "messages_page_up": "pageup,ctrl+alt+b",
    "messages_page_down": "pagedown,ctrl+alt+f",
    "messages_line_up": "ctrl+alt+y",
    "messages_line_down": "ctrl+alt+e",
    "messages_half_page_up": "ctrl+alt+u",
    "messages_half_page_down": "ctrl+alt+d",
    "messages_first": "ctrl+g,home",
    "messages_last": "ctrl+alt+g,end",
    "messages_next": "none",
    "messages_previous": "none",
    "messages_copy": "y",
    "messages_undo": "u",
    "messages_redo": "r",
    "messages_last_user": "none",
    "messages_toggle_conceal": "h",
    "model_list": "m",
    "model_cycle_recent": "f2",
    "model_cycle_recent_reverse": "shift+f2",
    "model_cycle_favorite": "none",
    "model_cycle_favorite_reverse": "none",
    "variant_cycle": "ctrl+t",
    "command_list": "ctrl+p",
    "agent_list": "a",
    "agent_cycle": "tab",
    "agent_cycle_reverse": "shift+tab",
    "input_clear": "ctrl+c",
    "input_paste": "ctrl+v",
    "input_submit": "return",
    "input_newline": "shift+return,ctrl+return,alt+return,ctrl+j",
    "input_move_left": "left,ctrl+b",
    "input_move_right": "right,ctrl+f",
    "input_move_up": "up",
    "input_move_down": "down",
    "input_select_left": "shift+left",
    "input_select_right": "shift+right",
    "input_select_up": "shift+up",
    "input_select_down": "shift+down",
    "input_line_home": "ctrl+a",
    "input_line_end": "ctrl+e",
    "input_select_line_home": "ctrl+shift+a",
    "input_select_line_end": "ctrl+shift+e",
    "input_visual_line_home": "alt+a",
    "input_visual_line_end": "alt+e",
    "input_select_visual_line_home": "alt+shift+a",
    "input_select_visual_line_end": "alt+shift+e",
    "input_buffer_home": "home",
    "input_buffer_end": "end",
    "input_select_buffer_home": "shift+home",
    "input_select_buffer_end": "shift+end",
    "input_delete_line": "ctrl+shift+d",
    "input_delete_to_line_end": "ctrl+k",
    "input_delete_to_line_start": "ctrl+u",
    "input_backspace": "backspace,shift+backspace",
    "input_delete": "ctrl+d,delete,shift+delete",
    "input_undo": "ctrl+-,super+z",
    "input_redo": "ctrl+.,super+shift+z",
    "input_word_forward": "alt+f,alt+right,ctrl+right",
    "input_word_backward": "alt+b,alt+left,ctrl+left",
    "input_select_word_forward": "alt+shift+f,alt+shift+right",
    "input_select_word_backward": "alt+shift+b,alt+shift+left",
    "input_delete_word_forward": "alt+d,alt+delete,ctrl+delete",
    "input_delete_word_backward": "ctrl+w,ctrl+backspace,alt+backspace",
    "history_previous": "up",
    "history_next": "down",
    "terminal_suspend": "ctrl+z",
    "terminal_title_toggle": "none",
    "tips_toggle": "h",
    "display_thinking": "none"
  }
}
```

---

## [Leader key](#leader-key)

OpenCode uses a `leader` key for most keybinds. This avoids conflicts in your terminal.

By default, `ctrl+x` is the leader key and most actions require you to first press the leader key and then the shortcut. For example, to start a new session you first press `ctrl+x` and then press `n`.

You don’t need to use a leader key for your keybinds but we recommend doing so.

Some navigation keybinds intentionally do not use the leader key by default. For subagent sessions, the defaults are `session_child_first` = `\down`, `session_child_cycle` = `right`, `session_child_cycle_reverse` = `left`, and `session_parent` = `up`.

---

## [Disable keybind](#disable-keybind)

You can disable a keybind by adding the key to `tui.json` with a value of “none”.

// tui.json
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "keybinds": {
    "session_compact": "none"
  }
}
```

---

## [Desktop prompt shortcuts](#desktop-prompt-shortcuts)

The OpenCode desktop app prompt input supports common Readline/Emacs-style shortcuts for editing text. These are built-in and currently not configurable via `opencode.json`.

ShortcutActionctrl+aMove to start of current linectrl+eMove to end of current linectrl+bMove cursor back one characterctrl+fMove cursor forward one characteralt+bMove cursor back one wordalt+fMove cursor forward one wordctrl+dDelete character under cursorctrl+kKill to end of linectrl+uKill to start of linectrl+wKill previous wordalt+dKill next wordctrl+tTranspose charactersctrl+gCancel popovers / abort running response

---

## [Shift+Enter](#shiftenter)

Some terminals don’t send modifier keys with Enter by default. You may need to configure your terminal to send `Shift+Enter` as an escape sequence.

### [Windows Terminal](#windows-terminal)

Open your `settings.json` at:

```plaintext
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

Add this to the root-level `actions` array:

```json
"actions": [
  {
    "command": {
      "action": "sendInput",
      "input": "\u001b[13;2u"
    },
    "id": "User.sendInput.ShiftEnterCustom"
  }
]
```

Add this to the root-level `keybindings` array:

```json
"keybindings": [
  {
    "keys": "shift+enter",
    "id": "User.sendInput.ShiftEnterCustom"
  }
]
```

Save the file and restart Windows Terminal or open a new tab.


---
# File: lsp.md
---
title: "LSP Servers"
source: "https://opencode.ai/docs/lsp/"
description: "OpenCode integrates with your LSP servers."
---

OpenCode integrates with your Language Server Protocol (LSP) to help the LLM interact with your codebase. It uses diagnostics to provide feedback to the LLM.

---

## [Built-in](#built-in)

OpenCode comes with several built-in LSP servers for popular languages:

LSP ServerExtensionsRequirementsastro.astroAuto-installs for Astro projectsbash.sh, .bash, .zsh, .kshAuto-installs bash-language-serverclangd.c, .cpp, .cc, .cxx, .c++, .h, .hpp, .hh, .hxx, .h++Auto-installs for C/C++ projectscsharp.cs.NET SDK installedclojure-lsp.clj, .cljs, .cljc, .ednclojure-lsp command availabledart.dartdart command availabledeno.ts, .tsx, .js, .jsx, .mjsdeno command available (auto-detects deno.json/deno.jsonc)elixir-ls.ex, .exselixir command availableeslint.ts, .tsx, .js, .jsx, .mjs, .cjs, .mts, .cts, .vueeslint dependency in projectfsharp.fs, .fsi, .fsx, .fsscript.NET SDK installedgleam.gleamgleam command availablegopls.gogo command availablehls.hs, .lhshaskell-language-server-wrapper command availablejdtls.javaJava SDK (version 21+) installedjulials.jljulia and LanguageServer.jl installedkotlin-ls.kt, .ktsAuto-installs for Kotlin projectslua-ls.luaAuto-installs for Lua projectsnixd.nixnixd command availableocaml-lsp.ml, .mliocamllsp command availableoxlint.ts, .tsx, .js, .jsx, .mjs, .cjs, .mts, .cts, .vue, .astro, .svelteoxlint dependency in projectphp intelephense.phpAuto-installs for PHP projectsprisma.prismaprisma command availablepyright.py, .pyipyright dependency installedruby-lsp (rubocop).rb, .rake, .gemspec, .ruruby and gem commands availablerust.rsrust-analyzer command availablesourcekit-lsp.swift, .objc, .objcppswift installed (xcode on macOS)svelte.svelteAuto-installs for Svelte projectsterraform.tf, .tfvarsAuto-installs from GitHub releasestinymist.typ, .typcAuto-installs from GitHub releasestypescript.ts, .tsx, .js, .jsx, .mjs, .cjs, .mts, .ctstypescript dependency in projectvue.vueAuto-installs for Vue projectsyaml-ls.yaml, .ymlAuto-installs Red Hat yaml-language-serverzls.zig, .zonzig command available

LSP servers are automatically enabled when one of the above file extensions are detected and the requirements are met.

> **Note:** You can disable automatic LSP server downloads by setting the `OPENCODE_DISABLE_LSP_DOWNLOAD` environment variable to `true`.

---

## [How It Works](#how-it-works)

When opencode opens a file, it:

- Checks the file extension against all enabled LSP servers.

- Starts the appropriate LSP server if not already running.

---

## [Configure](#configure)

You can customize LSP servers through the `lsp` section in your opencode config.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {}
}
```

Each LSP server supports the following:

PropertyTypeDescriptiondisabledbooleanSet this to true to disable the LSP servercommandstring[]The command to start the LSP serverextensionsstring[]File extensions this LSP server should handleenvobjectEnvironment variables to set when starting serverinitializationobjectInitialization options to send to the LSP server

Let’s look at some examples.

---

### [Environment variables](#environment-variables)

Use the `env` property to set environment variables when starting the LSP server:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "rust": {
      "env": {
        "RUST_LOG": "debug"
      }
    }
  }
}
```

---

### [Initialization options](#initialization-options)

Use the `initialization` property to pass initialization options to the LSP server. These are server-specific settings sent during the LSP `initialize` request:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "typescript": {
      "initialization": {
        "preferences": {
          "importModuleSpecifierPreference": "relative"
        }
      }
    }
  }
}
```

> **Note:** Initialization options vary by LSP server. Check your LSP server’s documentation for available options.

---

### [Disabling LSP servers](#disabling-lsp-servers)

To disable **all** LSP servers globally, set `lsp` to `false`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": false
}
```

To disable a **specific** LSP server, set `disabled` to `true`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "typescript": {
      "disabled": true
    }
  }
}
```

---

### [Custom LSP servers](#custom-lsp-servers)

You can add custom LSP servers by specifying the command and file extensions:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "lsp": {
    "custom-lsp": {
      "command": ["custom-lsp-server", "--stdio"],
      "extensions": [".custom"]
    }
  }
}
```

---

## [Additional Information](#additional-information)

### [PHP Intelephense](#php-intelephense)

PHP Intelephense offers premium features through a license key. You can provide a license key by placing (only) the key in a text file at:

- On macOS/Linux: `$HOME/intelephense/license.txt`

- On Windows: `%USERPROFILE%/intelephense/license.txt`

The file should contain only the license key with no additional content.


---
# File: mcp-servers.md
---
title: "MCP servers"
source: "https://opencode.ai/docs/mcp-servers/"
description: "Add local and remote MCP tools."
---

You can add external tools to OpenCode using the *Model Context Protocol*, or MCP. OpenCode supports both local and remote servers.

Once added, MCP tools are automatically available to the LLM alongside built-in tools.

---

#### [Caveats](#caveats)

When you use an MCP server, it adds to the context. This can quickly add up if you have a lot of tools. So we recommend being careful with which MCP servers you use.

> **Tip:** MCP servers add to your context, so you want to be careful with which ones you enable.

Certain MCP servers, like the GitHub MCP server, tend to add a lot of tokens and can easily exceed the context limit.

---

## [Enable](#enable)

You can define MCP servers in your [OpenCode Config](https://opencode.ai/docs/config/) under `mcp`. Add each MCP with a unique name. You can refer to that MCP by name when prompting the LLM.

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "name-of-mcp-server": {
      // ...
      "enabled": true,
    },
    "name-of-other-mcp-server": {
      // ...
    },
  },
}
```

You can also disable a server by setting `enabled` to `false`. This is useful if you want to temporarily disable a server without removing it from your config.

---

### [Overriding remote defaults](#overriding-remote-defaults)

Organizations can provide default MCP servers via their `.well-known/opencode` endpoint. These servers may be disabled by default, allowing users to opt-in to the ones they need.

To enable a specific server from your organization’s remote config, add it to your local config with `enabled: true`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "jira": {
      "type": "remote",
      "url": "https://jira.example.com/mcp",
      "enabled": true
    }
  }
}
```

Your local config values override the remote defaults. See [config precedence](/docs/config#precedence-order) for more details.

---

## [Local](#local)

Add local MCP servers using `type` to `"local"` within the MCP object.

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-local-mcp-server": {
      "type": "local",
      // Or ["bun", "x", "my-mcp-command"]
      "command": ["npx", "-y", "my-mcp-command"],
      "enabled": true,
      "environment": {
        "MY_ENV_VAR": "my_env_var_value",
      },
    },
  },
}
```

The command is how the local MCP server is started. You can also pass in a list of environment variables as well.

For example, here’s how you can add the test [`@modelcontextprotocol/server-everything`](https://www.npmjs.com/package/@modelcontextprotocol/server-everything) MCP server.

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "mcp_everything": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-everything"],
    },
  },
}
```

And to use it I can add `use the mcp_everything tool` to my prompts.

```txt
use the mcp_everything tool to add the number 3 and 4
```

---

#### [Options](#options)

Here are all the options for configuring a local MCP server.

OptionTypeRequiredDescriptiontypeStringYType of MCP server connection, must be "local".commandArrayYCommand and arguments to run the MCP server.environmentObjectEnvironment variables to set when running the server.enabledBooleanEnable or disable the MCP server on startup.timeoutNumberTimeout in ms for fetching tools from the MCP server. Defaults to 5000 (5 seconds).

---

## [Remote](#remote)

Add remote MCP servers by setting `type` to `"remote"`.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-remote-mcp": {
      "type": "remote",
      "url": "https://my-mcp-server.com",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer MY_API_KEY"
      }
    }
  }
}
```

The `url` is the URL of the remote MCP server and with the `headers` option you can pass in a list of headers.

---

#### [Options](#options-1)

OptionTypeRequiredDescriptiontypeStringYType of MCP server connection, must be "remote".urlStringYURL of the remote MCP server.enabledBooleanEnable or disable the MCP server on startup.headersObjectHeaders to send with the request.oauthObjectOAuth authentication configuration. See OAuth section below.timeoutNumberTimeout in ms for fetching tools from the MCP server. Defaults to 5000 (5 seconds).

---

## [OAuth](#oauth)

OpenCode automatically handles OAuth authentication for remote MCP servers. When a server requires authentication, OpenCode will:

- Detect the 401 response and initiate the OAuth flow

- Use **Dynamic Client Registration (RFC 7591)** if supported by the server

- Store tokens securely for future requests

---

### [Automatic](#automatic)

For most OAuth-enabled MCP servers, no special configuration is needed. Just configure the remote server:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-oauth-server": {
      "type": "remote",
      "url": "https://mcp.example.com/mcp"
    }
  }
}
```

If the server requires authentication, OpenCode will prompt you to authenticate when you first try to use it. If not, you can [manually trigger the flow](#authenticating) with `opencode mcp auth `.

---

### [Pre-registered](#pre-registered)

If you have client credentials from the MCP server provider, you can configure them:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-oauth-server": {
      "type": "remote",
      "url": "https://mcp.example.com/mcp",
      "oauth": {
        "clientId": "{env:MY_MCP_CLIENT_ID}",
        "clientSecret": "{env:MY_MCP_CLIENT_SECRET}",
        "scope": "tools:read tools:execute"
      }
    }
  }
}
```

---

### [Authenticating](#authenticating)

You can manually trigger authentication or manage credentials.

Authenticate with a specific MCP server:

```bash
opencode mcp auth my-oauth-server
```

List all MCP servers and their auth status:

```bash
opencode mcp list
```

Remove stored credentials:

```bash
opencode mcp logout my-oauth-server
```

The `mcp auth` command will open your browser for authorization. After you authorize, OpenCode will store the tokens securely in `~/.local/share/opencode/mcp-auth.json`.

---

#### [Disabling OAuth](#disabling-oauth)

If you want to disable automatic OAuth for a server (e.g., for servers that use API keys instead), set `oauth` to `false`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-api-key-server": {
      "type": "remote",
      "url": "https://mcp.example.com/mcp",
      "oauth": false,
      "headers": {
        "Authorization": "Bearer {env:MY_API_KEY}"
      }
    }
  }
}
```

---

#### [OAuth Options](#oauth-options)

OptionTypeDescriptionoauthObject | falseOAuth config object, or false to disable OAuth auto-detection.clientIdStringOAuth client ID. If not provided, dynamic client registration will be attempted.clientSecretStringOAuth client secret, if required by the authorization server.scopeStringOAuth scopes to request during authorization.

#### [Debugging](#debugging)

If a remote MCP server is failing to authenticate, you can diagnose issues with:

```bash
# View auth status for all OAuth-capable servers
opencode mcp auth list

# Debug connection and OAuth flow for a specific server
opencode mcp debug my-oauth-server
```

The `mcp debug` command shows the current auth status, tests HTTP connectivity, and attempts the OAuth discovery flow.

---

## [Manage](#manage)

Your MCPs are available as tools in OpenCode, alongside built-in tools. So you can manage them through the OpenCode config like any other tool.

---

### [Global](#global)

This means that you can enable or disable them globally.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-mcp-foo": {
      "type": "local",
      "command": ["bun", "x", "my-mcp-command-foo"]
    },
    "my-mcp-bar": {
      "type": "local",
      "command": ["bun", "x", "my-mcp-command-bar"]
    }
  },
  "tools": {
    "my-mcp-foo": false
  }
}
```

We can also use a glob pattern to disable all matching MCPs.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-mcp-foo": {
      "type": "local",
      "command": ["bun", "x", "my-mcp-command-foo"]
    },
    "my-mcp-bar": {
      "type": "local",
      "command": ["bun", "x", "my-mcp-command-bar"]
    }
  },
  "tools": {
    "my-mcp*": false
  }
}
```

Here we are using the glob pattern `my-mcp*` to disable all MCPs.

---

### [Per agent](#per-agent)

If you have a large number of MCP servers you may want to only enable them per agent and disable them globally. To do this:

- Disable it as a tool globally.

- In your [agent config](/docs/agents#tools), enable the MCP server as a tool.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "my-mcp": {
      "type": "local",
      "command": ["bun", "x", "my-mcp-command"],
      "enabled": true
    }
  },
  "tools": {
    "my-mcp*": false
  },
  "agent": {
    "my-agent": {
      "tools": {
        "my-mcp*": true
      }
    }
  }
}
```

---

#### [Glob patterns](#glob-patterns)

The glob pattern uses simple regex globbing patterns:

- `*` matches zero or more of any character (e.g., `"my-mcp*"` matches `my-mcp_search`, `my-mcp_list`, etc.)

- `?` matches exactly one character

- All other characters match literally

> **Note:** MCP server tools are registered with server name as prefix, so to disable all tools for a server simply use:

---

## [Examples](#examples)

Below are examples of some common MCP servers. You can submit a PR if you want to document other servers.

---

### [Sentry](#sentry)

Add the [Sentry MCP server](https://mcp.sentry.dev) to interact with your Sentry projects and issues.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "sentry": {
      "type": "remote",
      "url": "https://mcp.sentry.dev/mcp",
      "oauth": {}
    }
  }
}
```

After adding the configuration, authenticate with Sentry:

```bash
opencode mcp auth sentry
```

This will open a browser window to complete the OAuth flow and connect OpenCode to your Sentry account.

Once authenticated, you can use Sentry tools in your prompts to query issues, projects, and error data.

```txt
Show me the latest unresolved issues in my project. use sentry
```

---

### [Context7](#context7)

Add the [Context7 MCP server](https://github.com/upstash/context7) to search through docs.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp"
    }
  }
}
```

If you have signed up for a free account, you can use your API key and get higher rate-limits.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}"
      }
    }
  }
}
```

Here we are assuming that you have the `CONTEXT7_API_KEY` environment variable set.

Add `use context7` to your prompts to use Context7 MCP server.

```txt
Configure a Cloudflare Worker script to cache JSON API responses for five minutes. use context7
```

Alternatively, you can add something like this to your [AGENTS.md](/docs/rules/).

// AGENTS.md
```md
When you need to search docs, use `context7` tools.
```

---

### [Grep by Vercel](#grep-by-vercel)

Add the [Grep by Vercel](https://grep.app) MCP server to search through code snippets on GitHub.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "gh_grep": {
      "type": "remote",
      "url": "https://mcp.grep.app"
    }
  }
}
```

Since we named our MCP server `gh_grep`, you can add `use the gh_grep tool` to your prompts to get the agent to use it.

```txt
What's the right way to set a custom domain in an SST Astro component? use the gh_grep tool
```

Alternatively, you can add something like this to your [AGENTS.md](/docs/rules/).

// AGENTS.md
```md
If you are unsure how to do something, use `gh_grep` to search code examples from GitHub.
```


---
# File: models.md
---
title: "Models"
source: "https://opencode.ai/docs/models/"
description: "Configuring an LLM provider and model."
---

OpenCode uses the [AI SDK](https://ai-sdk.dev/) and [Models.dev](https://models.dev) to support **75+ LLM providers** and it supports running local models.

---

## [Providers](#providers)

Most popular providers are preloaded by default. If you’ve added the credentials for a provider through the `/connect` command, they’ll be available when you start OpenCode.

Learn more about [providers](/docs/providers).

---

## [Select a model](#select-a-model)

Once you’ve configured your provider you can select the model you want by typing in:

```bash
/models
```

---

## [Recommended models](#recommended-models)

There are a lot of models out there, with new models coming out every week.

> **Tip:** Consider using one of the models we recommend.

However, there are only a few of them that are good at both generating code and tool calling.

Here are several models that work well with OpenCode, in no particular order. (This is not an exhaustive list nor is it necessarily up to date):

- GPT 5.2

- GPT 5.1 Codex

- Claude Opus 4.5

- Claude Sonnet 4.5

- Minimax M2.1

- Gemini 3 Pro

---

## [Set a default](#set-a-default)

To set one of these as the default model, you can set the `model` key in your OpenCode config.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "lmstudio/google/gemma-3n-e4b"
}
```

Here the full ID is `provider_id/model_id`. For example, if you’re using [OpenCode Zen](/docs/zen), you would use `opencode/gpt-5.1-codex` for GPT 5.1 Codex.

If you’ve configured a [custom provider](/docs/providers#custom), the `provider_id` is key from the `provider` part of your config, and the `model_id` is the key from `provider.models`.

---

## [Configure models](#configure-models)

You can globally configure a model’s options through the config.

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "openai": {
      "models": {
        "gpt-5": {
          "options": {
            "reasoningEffort": "high",
            "textVerbosity": "low",
            "reasoningSummary": "auto",
            "include": ["reasoning.encrypted_content"],
          },
        },
      },
    },
    "anthropic": {
      "models": {
        "claude-sonnet-4-5-20250929": {
          "options": {
            "thinking": {
              "type": "enabled",
              "budgetTokens": 16000,
            },
          },
        },
      },
    },
  },
}
```

Here we’re configuring global settings for two built-in models: `gpt-5` when accessed via the `openai` provider, and `claude-sonnet-4-20250514` when accessed via the `anthropic` provider. The built-in provider and model names can be found on [Models.dev](https://models.dev).

You can also configure these options for any agents that you are using. The agent config overrides any global options here. [Learn more](/docs/agents/#additional).

You can also define custom variants that extend built-in ones. Variants let you configure different settings for the same model without creating duplicate entries:

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "opencode": {
      "models": {
        "gpt-5": {
          "variants": {
            "high": {
              "reasoningEffort": "high",
              "textVerbosity": "low",
              "reasoningSummary": "auto",
            },
            "low": {
              "reasoningEffort": "low",
              "textVerbosity": "low",
              "reasoningSummary": "auto",
            },
          },
        },
      },
    },
  },
}
```

---

## [Variants](#variants)

Many models support multiple variants with different configurations. OpenCode ships with built-in default variants for popular providers.

### [Built-in variants](#built-in-variants)

OpenCode ships with default variants for many providers:

**Anthropic**:

- `high` - High thinking budget (default)

- `max` - Maximum thinking budget

**OpenAI**:

Varies by model but roughly:

- `none` - No reasoning

- `minimal` - Minimal reasoning effort

- `low` - Low reasoning effort

- `medium` - Medium reasoning effort

- `high` - High reasoning effort

- `xhigh` - Extra high reasoning effort

**Google**:

- `low` - Lower effort/token budget

- `high` - Higher effort/token budget

> **Tip:** This list is not comprehensive. Many other providers have built-in defaults too.

### [Custom variants](#custom-variants)

You can override existing variants or add your own:

// opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "openai": {
      "models": {
        "gpt-5": {
          "variants": {
            "thinking": {
              "reasoningEffort": "high",
              "textVerbosity": "low",
            },
            "fast": {
              "disabled": true,
            },
          },
        },
      },
    },
  },
}
```

### [Cycle variants](#cycle-variants)

Use the keybind `variant_cycle` to quickly switch between variants. [Learn more](/docs/keybinds).

---

## [Loading models](#loading-models)

When OpenCode starts up, it checks for models in the following priority order:

- The `--model` or `-m` command line flag. The format is the same as in the config file: `provider_id/model_id`.

- The model list in the OpenCode config. // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "model": "anthropic/claude-sonnet-4-20250514" } ``` The format here is `provider/model`.

- The last used model.

- The first model using an internal priority.


---
# File: network.md
---
title: "Network"
source: "https://opencode.ai/docs/network/"
description: "Configure proxies and custom certificates."
---

OpenCode supports standard proxy environment variables and custom certificates for enterprise network environments.

---

## [Proxy](#proxy)

OpenCode respects standard proxy environment variables.

```bash
# HTTPS proxy (recommended)
export HTTPS_PROXY=https://proxy.example.com:8080

# HTTP proxy (if HTTPS not available)
export HTTP_PROXY=http://proxy.example.com:8080

# Bypass proxy for local server (required)
export NO_PROXY=localhost,127.0.0.1
```

> **Caution:** The TUI communicates with a local HTTP server. You must bypass the proxy for this connection to prevent routing loops.

You can configure the server’s port and hostname using [CLI flags](/docs/cli#run).

---

### [Authenticate](#authenticate)

If your proxy requires basic authentication, include credentials in the URL.

```bash
export HTTPS_PROXY=http://username:password@proxy.example.com:8080
```

> **Caution:** Avoid hardcoding passwords. Use environment variables or secure credential storage.

For proxies requiring advanced authentication like NTLM or Kerberos, consider using an LLM Gateway that supports your authentication method.

---

## [Custom certificates](#custom-certificates)

If your enterprise uses custom CAs for HTTPS connections, configure OpenCode to trust them.

```bash
export NODE_EXTRA_CA_CERTS=/path/to/ca-cert.pem
```

This works for both proxy connections and direct API access.


---
# File: permissions.md
---
title: "Permissions"
source: "https://opencode.ai/docs/permissions/"
description: "Control which actions require approval to run."
---

OpenCode uses the `permission` config to decide whether a given action should run automatically, prompt you, or be blocked.

As of `v1.1.1`, the legacy `tools` boolean config is deprecated and has been merged into `permission`. The old `tools` config is still supported for backwards compatibility.

---

## [Actions](#actions)

Each permission rule resolves to one of:

- `"allow"` — run without approval

- `"ask"` — prompt for approval

- `"deny"` — block the action

---

## [Configuration](#configuration)

You can set permissions globally (with `*`), and override specific tools.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "*": "ask",
    "bash": "allow",
    "edit": "deny"
  }
}
```

You can also set all permissions at once:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": "allow"
}
```

---

## [Granular Rules (Object Syntax)](#granular-rules-object-syntax)

For most permissions, you can use an object to apply different actions based on the tool input.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": {
      "*": "ask",
      "git *": "allow",
      "npm *": "allow",
      "rm *": "deny",
      "grep *": "allow"
    },
    "edit": {
      "*": "deny",
      "packages/web/src/content/docs/*.mdx": "allow"
    }
  }
}
```

Rules are evaluated by pattern match, with the **last matching rule winning**. A common pattern is to put the catch-all `"*"` rule first, and more specific rules after it.

### [Wildcards](#wildcards)

Permission patterns use simple wildcard matching:

- `*` matches zero or more of any character

- `?` matches exactly one character

- All other characters match literally

### [Home Directory Expansion](#home-directory-expansion)

You can use `~` or `$HOME` at the start of a pattern to reference your home directory. This is particularly useful for [`external_directory`](#external-directories) rules.

- `~/projects/*` -> `/Users/username/projects/*`

- `$HOME/projects/*` -> `/Users/username/projects/*`

- `~` -> `/Users/username`

### [External Directories](#external-directories)

Use `external_directory` to allow tool calls that touch paths outside the working directory where OpenCode was started. This applies to any tool that takes a path as input (for example `read`, `edit`, `list`, `glob`, `grep`, and many `bash` commands).

Home expansion (like `~/...`) only affects how a pattern is written. It does not make an external path part of the current workspace, so paths outside the working directory must still be allowed via `external_directory`.

For example, this allows access to everything under `~/projects/personal/`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "external_directory": {
      "~/projects/personal/**": "allow"
    }
  }
}
```

Any directory allowed here inherits the same defaults as the current workspace. Since [`read` defaults to `allow`](#defaults), reads are also allowed for entries under `external_directory` unless overridden. Add explicit rules when a tool should be restricted in these paths, such as blocking edits while keeping reads:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "external_directory": {
      "~/projects/personal/**": "allow"
    },
    "edit": {
      "~/projects/personal/**": "deny"
    }
  }
}
```

Keep the list focused on trusted paths, and layer extra allow or deny rules as needed for other tools (for example `bash`).

---

## [Available Permissions](#available-permissions)

OpenCode permissions are keyed by tool name, plus a couple of safety guards:

- `read` — reading a file (matches the file path)

- `edit` — all file modifications (covers `edit`, `write`, `patch`, `multiedit`)

- `glob` — file globbing (matches the glob pattern)

- `grep` — content search (matches the regex pattern)

- `list` — listing files in a directory (matches the directory path)

- `bash` — running shell commands (matches parsed commands like `git status --porcelain`)

- `task` — launching subagents (matches the subagent type)

- `skill` — loading a skill (matches the skill name)

- `lsp` — running LSP queries (currently non-granular)

- `question` — asking the user questions during execution

- `webfetch` — fetching a URL (matches the URL)

- `websearch`, `codesearch` — web/code search (matches the query)

- `external_directory` — triggered when a tool touches paths outside the project working directory

- `doom_loop` — triggered when the same tool call repeats 3 times with identical input

---

## [Defaults](#defaults)

If you don’t specify anything, OpenCode starts from permissive defaults:

- Most permissions default to `"allow"`.

- `doom_loop` and `external_directory` default to `"ask"`.

- `read` is `"allow"`, but `.env` files are denied by default:

// opencode.json
```json
{
  "permission": {
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny",
      "*.env.example": "allow"
    }
  }
}
```

---

## [What “Ask” Does](#what-ask-does)

When OpenCode prompts for approval, the UI offers three outcomes:

- `once` — approve just this request

- `always` — approve future requests matching the suggested patterns (for the rest of the current OpenCode session)

- `reject` — deny the request

The set of patterns that `always` would approve is provided by the tool (for example, bash approvals typically whitelist a safe command prefix like `git status*`).

---

## [Agents](#agents)

You can override permissions per agent. Agent permissions are merged with the global config, and agent rules take precedence. [Learn more](/docs/agents#permissions) about agent permissions.

> **Note:** Refer to the [Granular Rules (Object Syntax)](#granular-rules-object-syntax) section above for more detailed pattern matching examples.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": {
      "*": "ask",
      "git *": "allow",
      "git commit *": "deny",
      "git push *": "deny",
      "grep *": "allow"
    }
  },
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "*": "ask",
          "git *": "allow",
          "git commit *": "ask",
          "git push *": "deny",
          "grep *": "allow"
        }
      }
    }
  }
}
```

You can also configure agent permissions in Markdown:

// ~/.config/opencode/agents/review.md
```markdown
---
description: Code review without edits
mode: subagent
permission:
  edit: deny
  bash: ask
  webfetch: deny
---

Only analyze code and suggest changes.
```

> **Tip:** Use pattern matching for commands with arguments. `"grep *"` allows `grep pattern file.txt`, while `"grep"` alone would block it. Commands like `git status` work for default behavior but require explicit permission (like `"git status *"`) when arguments are passed.


---
# File: plugins.md
---
title: "Plugins"
source: "https://opencode.ai/docs/plugins/"
description: "Write your own plugins to extend OpenCode."
---

Plugins allow you to extend OpenCode by hooking into various events and customizing behavior. You can create plugins to add new features, integrate with external services, or modify OpenCode’s default behavior.

For examples, check out the [plugins](/docs/ecosystem#plugins) created by the community.

---

## [Use a plugin](#use-a-plugin)

There are two ways to load plugins.

---

### [From local files](#from-local-files)

Place JavaScript or TypeScript files in the plugin directory.

- `.opencode/plugins/` - Project-level plugins

- `~/.config/opencode/plugins/` - Global plugins

Files in these directories are automatically loaded at startup.

---

### [From npm](#from-npm)

Specify npm packages in your config file.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-helicone-session", "opencode-wakatime", "@my-org/custom-plugin"]
}
```

Both regular and scoped npm packages are supported.

Browse available plugins in the [ecosystem](/docs/ecosystem#plugins).

---

### [How plugins are installed](#how-plugins-are-installed)

**npm plugins** are installed automatically using Bun at startup. Packages and their dependencies are cached in `~/.cache/opencode/node_modules/`.

**Local plugins** are loaded directly from the plugin directory. To use external packages, you must create a `package.json` within your config directory (see [Dependencies](#dependencies)), or publish the plugin to npm and [add it to your config](/docs/config#plugins).

---

### [Load order](#load-order)

Plugins are loaded from all sources and all hooks run in sequence. The load order is:

- Global config (`~/.config/opencode/opencode.json`)

- Project config (`opencode.json`)

- Global plugin directory (`~/.config/opencode/plugins/`)

- Project plugin directory (`.opencode/plugins/`)

Duplicate npm packages with the same name and version are loaded once. However, a local plugin and an npm plugin with similar names are both loaded separately.

---

## [Create a plugin](#create-a-plugin)

A plugin is a **JavaScript/TypeScript module** that exports one or more plugin functions. Each function receives a context object and returns a hooks object.

---

### [Dependencies](#dependencies)

Local plugins and custom tools can use external npm packages. Add a `package.json` to your config directory with the dependencies you need.

// .opencode/package.json
```json
{
  "dependencies": {
    "shescape": "^2.1.0"
  }
}
```

OpenCode runs `bun install` at startup to install these. Your plugins and tools can then import them.

// .opencode/plugins/my-plugin.ts
```ts
import { escape } from "shescape"

export const MyPlugin = async (ctx) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "bash") {
        output.args.command = escape(output.args.command)
      }
    },
  }
}
```

---

### [Basic structure](#basic-structure)

// .opencode/plugins/example.js
```js
export const MyPlugin = async ({ project, client, $, directory, worktree }) => {
  console.log("Plugin initialized!")

  return {
    // Hook implementations go here
  }
}
```

The plugin function receives:

- `project`: The current project information.

- `directory`: The current working directory.

- `worktree`: The git worktree path.

- `client`: An opencode SDK client for interacting with the AI.

- `$`: Bun’s [shell API](https://bun.com/docs/runtime/shell) for executing commands.

---

### [TypeScript support](#typescript-support)

For TypeScript plugins, you can import types from the plugin package:

// my-plugin.ts
```ts
import type { Plugin } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async ({ project, client, $, directory, worktree }) => {
  return {
    // Type-safe hook implementations
  }
}
```

---

### [Events](#events)

Plugins can subscribe to events as seen below in the Examples section. Here is a list of the different events available.

#### [Command Events](#command-events)

- `command.executed`

#### [File Events](#file-events)

- `file.edited`

- `file.watcher.updated`

#### [Installation Events](#installation-events)

- `installation.updated`

#### [LSP Events](#lsp-events)

- `lsp.client.diagnostics`

- `lsp.updated`

#### [Message Events](#message-events)

- `message.part.removed`

- `message.part.updated`

- `message.removed`

- `message.updated`

#### [Permission Events](#permission-events)

- `permission.asked`

- `permission.replied`

#### [Server Events](#server-events)

- `server.connected`

#### [Session Events](#session-events)

- `session.created`

- `session.compacted`

- `session.deleted`

- `session.diff`

- `session.error`

- `session.idle`

- `session.status`

- `session.updated`

#### [Todo Events](#todo-events)

- `todo.updated`

#### [Shell Events](#shell-events)

- `shell.env`

#### [Tool Events](#tool-events)

- `tool.execute.after`

- `tool.execute.before`

#### [TUI Events](#tui-events)

- `tui.prompt.append`

- `tui.command.execute`

- `tui.toast.show`

---

## [Examples](#examples)

Here are some examples of plugins you can use to extend opencode.

---

### [Send notifications](#send-notifications)

Send notifications when certain events occur:

// .opencode/plugins/notification.js
```js
export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      // Send notification on session completion
      if (event.type === "session.idle") {
        await $`osascript -e 'display notification "Session completed!" with title "opencode"'`
      }
    },
  }
}
```

We are using `osascript` to run AppleScript on macOS. Here we are using it to send notifications.

> **Note:** If you’re using the OpenCode desktop app, it can send system notifications automatically when a response is ready or when a session errors.

---

### [.env protection](#env-protection)

Prevent opencode from reading `.env` files:

// .opencode/plugins/env-protection.js
```javascript
export const EnvProtection = async ({ project, client, $, directory, worktree }) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read" && output.args.filePath.includes(".env")) {
        throw new Error("Do not read .env files")
      }
    },
  }
}
```

---

### [Inject environment variables](#inject-environment-variables)

Inject environment variables into all shell execution (AI tools and user terminals):

// .opencode/plugins/inject-env.js
```javascript
export const InjectEnvPlugin = async () => {
  return {
    "shell.env": async (input, output) => {
      output.env.MY_API_KEY = "secret"
      output.env.PROJECT_ROOT = input.cwd
    },
  }
}
```

---

### [Custom tools](#custom-tools)

Plugins can also add custom tools to opencode:

// .opencode/plugins/custom-tools.ts
```ts
import { type Plugin, tool } from "@opencode-ai/plugin"

export const CustomToolsPlugin: Plugin = async (ctx) => {
  return {
    tool: {
      mytool: tool({
        description: "This is a custom tool",
        args: {
          foo: tool.schema.string(),
        },
        async execute(args, context) {
          const { directory, worktree } = context
          return `Hello ${args.foo} from ${directory} (worktree: ${worktree})`
        },
      }),
    },
  }
}
```

The `tool` helper creates a custom tool that opencode can call. It takes a Zod schema function and returns a tool definition with:

- `description`: What the tool does

- `args`: Zod schema for the tool’s arguments

- `execute`: Function that runs when the tool is called

Your custom tools will be available to opencode alongside built-in tools.

> **Note:** If a plugin tool uses the same name as a built-in tool, the plugin tool takes precedence.

---

### [Logging](#logging)

Use `client.app.log()` instead of `console.log` for structured logging:

// .opencode/plugins/my-plugin.ts
```ts
export const MyPlugin = async ({ client }) => {
  await client.app.log({
    body: {
      service: "my-plugin",
      level: "info",
      message: "Plugin initialized",
      extra: { foo: "bar" },
    },
  })
}
```

Levels: `debug`, `info`, `warn`, `error`. See [SDK documentation](https://opencode.ai/docs/sdk) for details.

---

### [Compaction hooks](#compaction-hooks)

Customize the context included when a session is compacted:

// .opencode/plugins/compaction.ts
```ts
import type { Plugin } from "@opencode-ai/plugin"

export const CompactionPlugin: Plugin = async (ctx) => {
  return {
    "experimental.session.compacting": async (input, output) => {
      // Inject additional context into the compaction prompt
      output.context.push(`
## Custom Context

Include any state that should persist across compaction:
- Current task status
- Important decisions made
- Files being actively worked on
`)
    },
  }
}
```

The `experimental.session.compacting` hook fires before the LLM generates a continuation summary. Use it to inject domain-specific context that the default compaction prompt would miss.

You can also replace the compaction prompt entirely by setting `output.prompt`:

// .opencode/plugins/custom-compaction.ts
```ts
import type { Plugin } from "@opencode-ai/plugin"

export const CustomCompactionPlugin: Plugin = async (ctx) => {
  return {
    "experimental.session.compacting": async (input, output) => {
      // Replace the entire compaction prompt
      output.prompt = `
You are generating a continuation prompt for a multi-agent swarm session.

Summarize:
1. The current task and its status
2. Which files are being modified and by whom
3. Any blockers or dependencies between agents
4. The next steps to complete the work

Format as a structured prompt that a new agent can use to resume work.
`
    },
  }
}
```

When `output.prompt` is set, it completely replaces the default compaction prompt. The `output.context` array is ignored in this case.


---
# File: providers#directory.md
---
title: "Providers"
source: "https://opencode.ai/docs/providers/"
description: "Using any LLM provider in OpenCode."
---

OpenCode uses the [AI SDK](https://ai-sdk.dev/) and [Models.dev](https://models.dev) to support **75+ LLM providers** and it supports running local models.

To add a provider you need to:

- Add the API keys for the provider using the `/connect` command.

- Configure the provider in your OpenCode config.

---

### [Credentials](#credentials)

When you add a provider’s API keys with the `/connect` command, they are stored in `~/.local/share/opencode/auth.json`.

---

### [Config](#config)

You can customize the providers through the `provider` section in your OpenCode config.

---

#### [Base URL](#base-url)

You can customize the base URL for any provider by setting the `baseURL` option. This is useful when using proxy services or custom endpoints.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "anthropic": {
      "options": {
        "baseURL": "https://api.anthropic.com/v1"
      }
    }
  }
}
```

---

## [OpenCode Zen](#opencode-zen)

OpenCode Zen is a list of models provided by the OpenCode team that have been tested and verified to work well with OpenCode. [Learn more](/docs/zen).

> **Tip:** If you are new, we recommend starting with OpenCode Zen.

- Run the `/connect` command in the TUI, select `OpenCode Zen`, and head to [opencode.ai/auth](https://opencode.ai/zen). ```txt /connect ```

- Sign in, add your billing details, and copy your API key.

- Paste your API key. ```txt ┌ API key │ │ └ enter ```

- Run `/models` in the TUI to see the list of models we recommend. ```txt /models ```

It works like any other provider in OpenCode and is completely optional to use.

---

## [OpenCode Go](#opencode-go)

OpenCode Go is a low cost subscription plan that provides reliable access to popular open coding models provided by the OpenCode team that have been tested and verified to work well with OpenCode.

- Run the `/connect` command in the TUI, select `OpenCode Go`, and head to [opencode.ai/auth](https://opencode.ai/zen). ```txt /connect ```

- Sign in, add your billing details, and copy your API key.

- Paste your API key. ```txt ┌ API key │ │ └ enter ```

- Run `/models` in the TUI to see the list of models we recommend. ```txt /models ```

It works like any other provider in OpenCode and is completely optional to use.

---

## [Directory](#directory)

Let’s look at some of the providers in detail. If you’d like to add a provider to the list, feel free to open a PR.

> **Note:** Don’t see a provider here? Submit a PR.

---

### [302.AI](#302ai)

- Head over to the [302.AI console](https://302.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **302.AI**. ```txt /connect ```

- Enter your 302.AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Amazon Bedrock](#amazon-bedrock)

To use Amazon Bedrock with OpenCode:

- Head over to the **Model catalog** in the Amazon Bedrock console and request access to the models you want. > **Tip:** You need to have access to the model you want in Amazon Bedrock.

- **Configure authentication** using one of the following methods: --- #### [Environment Variables (Quick Start)](#environment-variables-quick-start) Set one of these environment variables while running opencode: ```bash # Option 1: Using AWS access keys AWS_ACCESS_KEY_ID=XXX AWS_SECRET_ACCESS_KEY=YYY opencode # Option 2: Using named AWS profile AWS_PROFILE=my-profile opencode # Option 3: Using Bedrock bearer token AWS_BEARER_TOKEN_BEDROCK=XXX opencode ``` Or add them to your bash profile: // ~/.bash_profile ```bash export AWS_PROFILE=my-dev-profile export AWS_REGION=us-east-1 ``` --- #### [Configuration File (Recommended)](#configuration-file-recommended) For project-specific or persistent configuration, use `opencode.json`: // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "amazon-bedrock": { "options": { "region": "us-east-1", "profile": "my-aws-profile" } } } } ``` **Available options:** `region` - AWS region (e.g., `us-east-1`, `eu-west-1`)

- `profile` - AWS named profile from `~/.aws/credentials`

- `endpoint` - Custom endpoint URL for VPC endpoints (alias for generic `baseURL` option)

> **Tip:** Configuration file options take precedence over environment variables.

---

#### [Advanced: VPC Endpoints](#advanced-vpc-endpoints)

If you’re using VPC endpoints for Bedrock:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "amazon-bedrock": {
      "options": {
        "region": "us-east-1",
        "profile": "production",
        "endpoint": "https://bedrock-runtime.us-east-1.vpce-xxxxx.amazonaws.com"
      }
    }
  }
}
```

> **Note:** The `endpoint` option is an alias for the generic `baseURL` option, using AWS-specific terminology. If both `endpoint` and `baseURL` are specified, `endpoint` takes precedence.

---

#### [Authentication Methods](#authentication-methods)

- **`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`**: Create an IAM user and generate access keys in the AWS Console

- **`AWS_PROFILE`**: Use named profiles from `~/.aws/credentials`. First configure with `aws configure --profile my-profile` or `aws sso login`

- **`AWS_BEARER_TOKEN_BEDROCK`**: Generate long-term API keys from the Amazon Bedrock console

- **`AWS_WEB_IDENTITY_TOKEN_FILE` / `AWS_ROLE_ARN`**: For EKS IRSA (IAM Roles for Service Accounts) or other Kubernetes environments with OIDC federation. These environment variables are automatically injected by Kubernetes when using service account annotations.

---

#### [Authentication Precedence](#authentication-precedence)

Amazon Bedrock uses the following authentication priority:

- **Bearer Token** - `AWS_BEARER_TOKEN_BEDROCK` environment variable or token from `/connect` command

- **AWS Credential Chain** - Profile, access keys, shared credentials, IAM roles, Web Identity Tokens (EKS IRSA), instance metadata

> **Note:** When a bearer token is set (via `/connect` or `AWS_BEARER_TOKEN_BEDROCK`), it takes precedence over all AWS credential methods including configured profiles.

- Run the `/models` command to select the model you want. ```txt /models ```

> **Note:** For custom inference profiles, use the model and provider name in the key and set the `id` property to the arn. This ensures correct caching.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "amazon-bedrock": {
      // ...
      "models": {
        "anthropic-claude-sonnet-4.5": {
          "id": "arn:aws:bedrock:us-east-1:xxx:application-inference-profile/yyy"
        }
      }
    }
  }
}
```

---

### [Anthropic](#anthropic)

- Once you’ve signed up, run the `/connect` command and select Anthropic. ```txt /connect ```

- Here you can select the **Claude Pro/Max** option and it’ll open your browser and ask you to authenticate. ```txt ┌ Select auth method │ │ Manually enter API Key └ ```

- Now all the Anthropic models should be available when you use the `/models` command. ```txt /models ```

There are plugins that allow you to use your Claude Pro/Max models with OpenCode. Anthropic explicitly prohibits this.

Previous versions of OpenCode came bundled with these plugins but that is no longer the case as of 1.3.0

Other companies support freedom of choice with developer tooling - you can use the following subscriptions in OpenCode with zero setup:

- ChatGPT Plus

- Github Copilot

- Gitlab Duo

---

### [Azure OpenAI](#azure-openai)

> **Note:** If you encounter “I’m sorry, but I cannot assist with that request” errors, try changing the content filter from **DefaultV2** to **Default** in your Azure resource.

- Head over to the [Azure portal](https://portal.azure.com/) and create an **Azure OpenAI** resource. You’ll need: **Resource name**: This becomes part of your API endpoint (`https://RESOURCE_NAME.openai.azure.com/`)

- **API key**: Either `KEY 1` or `KEY 2` from your resource

- Go to [Azure AI Foundry](https://ai.azure.com/) and deploy a model. > **Note:** The deployment name must match the model name for opencode to work properly.

- Run the `/connect` command and search for **Azure**. ```txt /connect ```

- Enter your API key. ```txt ┌ API key │ │ └ enter ```

- Set your resource name as an environment variable: ```bash AZURE_RESOURCE_NAME=XXX opencode ``` Or add it to your bash profile: // ~/.bash_profile ```bash export AZURE_RESOURCE_NAME=XXX ```

- Run the `/models` command to select your deployed model. ```txt /models ```

---

### [Azure Cognitive Services](#azure-cognitive-services)

- Head over to the [Azure portal](https://portal.azure.com/) and create an **Azure OpenAI** resource. You’ll need: **Resource name**: This becomes part of your API endpoint (`https://AZURE_COGNITIVE_SERVICES_RESOURCE_NAME.cognitiveservices.azure.com/`)

- **API key**: Either `KEY 1` or `KEY 2` from your resource

- Go to [Azure AI Foundry](https://ai.azure.com/) and deploy a model. > **Note:** The deployment name must match the model name for opencode to work properly.

- Run the `/connect` command and search for **Azure Cognitive Services**. ```txt /connect ```

- Enter your API key. ```txt ┌ API key │ │ └ enter ```

- Set your resource name as an environment variable: ```bash AZURE_COGNITIVE_SERVICES_RESOURCE_NAME=XXX opencode ``` Or add it to your bash profile: // ~/.bash_profile ```bash export AZURE_COGNITIVE_SERVICES_RESOURCE_NAME=XXX ```

- Run the `/models` command to select your deployed model. ```txt /models ```

---

### [Baseten](#baseten)

- Head over to the [Baseten](https://app.baseten.co/), create an account, and generate an API key.

- Run the `/connect` command and search for **Baseten**. ```txt /connect ```

- Enter your Baseten API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Cerebras](#cerebras)

- Head over to the [Cerebras console](https://inference.cerebras.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **Cerebras**. ```txt /connect ```

- Enter your Cerebras API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Qwen 3 Coder 480B*. ```txt /models ```

---

### [Cloudflare AI Gateway](#cloudflare-ai-gateway)

Cloudflare AI Gateway lets you access models from OpenAI, Anthropic, Workers AI, and more through a unified endpoint. With [Unified Billing](https://developers.cloudflare.com/ai-gateway/features/unified-billing/) you don’t need separate API keys for each provider.

- Head over to the [Cloudflare dashboard](https://dash.cloudflare.com/), navigate to **AI** > **AI Gateway**, and create a new gateway.

- Set your Account ID and Gateway ID as environment variables. // ~/.bash_profile ```bash export CLOUDFLARE_ACCOUNT_ID=your-32-character-account-id export CLOUDFLARE_GATEWAY_ID=your-gateway-id ```

- Run the `/connect` command and search for **Cloudflare AI Gateway**. ```txt /connect ```

- Enter your Cloudflare API token. ```txt ┌ API key │ │ └ enter ``` Or set it as an environment variable. // ~/.bash_profile ```bash export CLOUDFLARE_API_TOKEN=your-api-token ```

- Run the `/models` command to select a model. ```txt /models ``` You can also add models through your opencode config. // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "cloudflare-ai-gateway": { "models": { "openai/gpt-4o": {}, "anthropic/claude-sonnet-4": {} } } } } ```

---

### [Cloudflare Workers AI](#cloudflare-workers-ai)

Cloudflare Workers AI lets you run AI models on Cloudflare’s global network directly via REST API, with no separate provider accounts needed for supported models.

- Head over to the [Cloudflare dashboard](https://dash.cloudflare.com/), navigate to **Workers AI**, and select **Use REST API** to get your Account ID and create an API token.

- Set your Account ID as an environment variable. // ~/.bash_profile ```bash export CLOUDFLARE_ACCOUNT_ID=your-32-character-account-id ```

- Run the `/connect` command and search for **Cloudflare Workers AI**. ```txt /connect ```

- Enter your Cloudflare API token. ```txt ┌ API key │ │ └ enter ``` Or set it as an environment variable. // ~/.bash_profile ```bash export CLOUDFLARE_API_KEY=your-api-token ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Cortecs](#cortecs)

- Head over to the [Cortecs console](https://cortecs.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **Cortecs**. ```txt /connect ```

- Enter your Cortecs API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [DeepSeek](#deepseek)

- Head over to the [DeepSeek console](https://platform.deepseek.com/), create an account, and click **Create new API key**.

- Run the `/connect` command and search for **DeepSeek**. ```txt /connect ```

- Enter your DeepSeek API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a DeepSeek model like *DeepSeek Reasoner*. ```txt /models ```

---

### [Deep Infra](#deep-infra)

- Head over to the [Deep Infra dashboard](https://deepinfra.com/dash), create an account, and generate an API key.

- Run the `/connect` command and search for **Deep Infra**. ```txt /connect ```

- Enter your Deep Infra API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Firmware](#firmware)

- Head over to the [Firmware dashboard](https://app.firmware.ai/signup), create an account, and generate an API key.

- Run the `/connect` command and search for **Firmware**. ```txt /connect ```

- Enter your Firmware API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Fireworks AI](#fireworks-ai)

- Head over to the [Fireworks AI console](https://app.fireworks.ai/), create an account, and click **Create API Key**.

- Run the `/connect` command and search for **Fireworks AI**. ```txt /connect ```

- Enter your Fireworks AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [GitLab Duo](#gitlab-duo)

> **Caution:** GitLab Duo support in OpenCode is experimental. Features, configuration, and behavior may change in future releases.

OpenCode integrates with the [GitLab Duo Agent Platform](https://docs.gitlab.com/user/duo_agent_platform/), providing AI-powered agentic chat with native tool calling capabilities.

> **Note:** GitLab Duo Agent Platform requires a **Premium** or **Ultimate** GitLab subscription. It is available on GitLab.com and GitLab Self-Managed. See [GitLab Duo Agent Platform prerequisites](https://docs.gitlab.com/user/duo_agent_platform/#prerequisites) for full requirements.

- Run the `/connect` command and select GitLab. ```txt /connect ```

- Choose your authentication method: ```txt ┌ Select auth method │ │ OAuth (Recommended) │ Personal Access Token └ ``` #### [Using OAuth (Recommended)](#using-oauth-recommended) Select **OAuth** and your browser will open for authorization. #### [Using Personal Access Token](#using-personal-access-token) Go to [GitLab User Settings > Access Tokens](https://gitlab.com/-/user_settings/personal_access_tokens)

- Click **Add new token**

- Name: `OpenCode`, Scopes: `api`

- Copy the token (starts with `glpat-`)

- Enter it in the terminal

- Run the `/models` command to see available models. ```txt /models ``` Three Claude-based models are available: **duo-chat-haiku-4-5** (Default) - Fast responses for quick tasks

- **duo-chat-sonnet-4-5** - Balanced performance for most workflows

- **duo-chat-opus-4-5** - Most capable for complex analysis

> **Note:** You can also specify ‘GITLAB_TOKEN’ environment variable if you don’t want to store token in opencode auth storage.

##### [Self-Hosted GitLab](#self-hosted-gitlab)

> **Note:** OpenCode uses a small model for some AI tasks like generating the session title. It is configured to use gpt-5-nano by default, hosted by Zen. To lock OpenCode to only use your own GitLab-hosted instance, add the following to your `opencode.json` file. It is also recommended to disable session sharing.

For self-hosted GitLab instances:

```bash
export GITLAB_INSTANCE_URL=https://gitlab.company.com
export GITLAB_TOKEN=glpat-...
```

If your instance runs a custom AI Gateway:

```bash
GITLAB_AI_GATEWAY_URL=https://ai-gateway.company.com
```

Or add to your bash profile:

// ~/.bash_profile
```bash
export GITLAB_INSTANCE_URL=https://gitlab.company.com
export GITLAB_AI_GATEWAY_URL=https://ai-gateway.company.com
export GITLAB_TOKEN=glpat-...
```

> **Note:** Your GitLab administrator must:

##### [OAuth for Self-Hosted instances](#oauth-for-self-hosted-instances)

In order to make Oauth working for your self-hosted instance, you need to create a new application (Settings → Applications) with the callback URL `http://127.0.0.1:8080/callback` and following scopes:

- api (Access the API on your behalf)

- read_user (Read your personal information)

- read_repository (Allows read-only access to the repository)

Then expose application ID as environment variable:

```bash
export GITLAB_OAUTH_CLIENT_ID=your_application_id_here
```

More documentation on [opencode-gitlab-auth](https://www.npmjs.com/package/opencode-gitlab-auth) homepage.

##### [Configuration](#configuration)

Customize through `opencode.json`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "gitlab": {
      "options": {
        "instanceUrl": "https://gitlab.com"
      }
    }
  }
}
```

##### [GitLab Duo Agent Platform (DAP) Workflow Models](#gitlab-duo-agent-platform-dap-workflow-models)

DAP workflow models provide an alternative execution path that routes tool calls through GitLab’s Duo Workflow Service (DWS) instead of the standard agentic chat. When a `duo-workflow-*` model is selected, OpenCode will:

- Discover available models from your GitLab namespace

- Present a selection picker if multiple models are available

- Cache the selected model to disk for fast subsequent startups

- Route tool execution requests through OpenCode’s permission-gated tool system

Available DAP workflow models follow the `duo-workflow-*` naming convention and are dynamically discovered from your GitLab instance.

##### [GitLab API Tools (Optional, but highly recommended)](#gitlab-api-tools-optional-but-highly-recommended)

To access GitLab tools (merge requests, issues, pipelines, CI/CD, etc.):

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-gitlab-plugin"]
}
```

This plugin provides comprehensive GitLab repository management capabilities including MR reviews, issue tracking, pipeline monitoring, and more.

---

### [GitHub Copilot](#github-copilot)

To use your GitHub Copilot subscription with opencode:

> **Note:** Some models might need a [Pro+ subscription](https://github.com/features/copilot/plans) to use.

- Run the `/connect` command and search for GitHub Copilot. ```txt /connect ```

- Navigate to [github.com/login/device](https://github.com/login/device) and enter the code. ```txt ┌ Login with GitHub Copilot │ │ https://github.com/login/device │ │ Enter code: 8F43-6FCF │ └ Waiting for authorization... ```

- Now run the `/models` command to select the model you want. ```txt /models ```

---

### [Google Vertex AI](#google-vertex-ai)

To use Google Vertex AI with OpenCode:

- Head over to the **Model Garden** in the Google Cloud Console and check the models available in your region. > **Note:** You need to have a Google Cloud project with Vertex AI API enabled.

- Set the required environment variables: `GOOGLE_CLOUD_PROJECT`: Your Google Cloud project ID

- `VERTEX_LOCATION` (optional): The region for Vertex AI (defaults to `global`)

- Authentication (choose one): `GOOGLE_APPLICATION_CREDENTIALS`: Path to your service account JSON key file

- Authenticate using gcloud CLI: `gcloud auth application-default login`

Set them while running opencode.

```bash
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json GOOGLE_CLOUD_PROJECT=your-project-id opencode
```

Or add them to your bash profile.

// ~/.bash_profile
```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
export GOOGLE_CLOUD_PROJECT=your-project-id
export VERTEX_LOCATION=global
```

> **Tip:** The `global` region improves availability and reduces errors at no extra cost. Use regional endpoints (e.g., `us-central1`) for data residency requirements. [Learn more](https://cloud.google.com/vertex-ai/generative-ai/docs/partner-models/use-partner-models#regional_and_global_endpoints)

- Run the `/models` command to select the model you want. ```txt /models ```

---

### [Groq](#groq)

- Head over to the [Groq console](https://console.groq.com/), click **Create API Key**, and copy the key.

- Run the `/connect` command and search for Groq. ```txt /connect ```

- Enter the API key for the provider. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select the one you want. ```txt /models ```

---

### [Hugging Face](#hugging-face)

[Hugging Face Inference Providers](https://huggingface.co/docs/inference-providers) provides access to open models supported by 17+ providers.

- Head over to [Hugging Face settings](https://huggingface.co/settings/tokens/new?ownUserPermissions=inference.serverless.write&tokenType=fineGrained) to create a token with permission to make calls to Inference Providers.

- Run the `/connect` command and search for **Hugging Face**. ```txt /connect ```

- Enter your Hugging Face token. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi-K2-Instruct* or *GLM-4.6*. ```txt /models ```

---

### [Helicone](#helicone)

[Helicone](https://helicone.ai) is an LLM observability platform that provides logging, monitoring, and analytics for your AI applications. The Helicone AI Gateway routes your requests to the appropriate provider automatically based on the model.

- Head over to [Helicone](https://helicone.ai), create an account, and generate an API key from your dashboard.

- Run the `/connect` command and search for **Helicone**. ```txt /connect ```

- Enter your Helicone API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

For more providers and advanced features like caching and rate limiting, check the [Helicone documentation](https://docs.helicone.ai).

#### [Optional Configs](#optional-configs)

In the event you see a feature or model from Helicone that isn’t configured automatically through opencode, you can always configure it yourself.

Here’s [Helicone’s Model Directory](https://helicone.ai/models), you’ll need this to grab the IDs of the models you want to add.

// ~/.config/opencode/opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "helicone": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Helicone",
      "options": {
        "baseURL": "https://ai-gateway.helicone.ai",
      },
      "models": {
        "gpt-4o": {
          // Model ID (from Helicone's model directory page)
          "name": "GPT-4o", // Your own custom name for the model
        },
        "claude-sonnet-4-20250514": {
          "name": "Claude Sonnet 4",
        },
      },
    },
  },
}
```

#### [Custom Headers](#custom-headers)

Helicone supports custom headers for features like caching, user tracking, and session management. Add them to your provider config using `options.headers`:

// ~/.config/opencode/opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "helicone": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Helicone",
      "options": {
        "baseURL": "https://ai-gateway.helicone.ai",
        "headers": {
          "Helicone-Cache-Enabled": "true",
          "Helicone-User-Id": "opencode",
        },
      },
    },
  },
}
```

##### [Session tracking](#session-tracking)

Helicone’s [Sessions](https://docs.helicone.ai/features/sessions) feature lets you group related LLM requests together. Use the [opencode-helicone-session](https://github.com/H2Shami/opencode-helicone-session) plugin to automatically log each OpenCode conversation as a session in Helicone.

```bash
npm install -g opencode-helicone-session
```

Add it to your config.

// opencode.json
```json
{
  "plugin": ["opencode-helicone-session"]
}
```

The plugin injects `Helicone-Session-Id` and `Helicone-Session-Name` headers into your requests. In Helicone’s Sessions page, you’ll see each OpenCode conversation listed as a separate session.

##### [Common Helicone headers](#common-helicone-headers)

HeaderDescriptionHelicone-Cache-EnabledEnable response caching (true/false)Helicone-User-IdTrack metrics by userHelicone-Property-[Name]Add custom properties (e.g., Helicone-Property-Environment)Helicone-Prompt-IdAssociate requests with prompt versions

See the [Helicone Header Directory](https://docs.helicone.ai/helicone-headers/header-directory) for all available headers.

---

### [llama.cpp](#llamacpp)

You can configure opencode to use local models through [llama.cpp’s](https://github.com/ggml-org/llama.cpp) llama-server utility

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "llama.cpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "llama-server (local)",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "qwen3-coder:a3b": {
          "name": "Qwen3-Coder: a3b-30b (local)",
          "limit": {
            "context": 128000,
            "output": 65536
          }
        }
      }
    }
  }
}
```

In this example:

- `llama.cpp` is the custom provider ID. This can be any string you want.

- `npm` specifies the package to use for this provider. Here, `@ai-sdk/openai-compatible` is used for any OpenAI-compatible API.

- `name` is the display name for the provider in the UI.

- `options.baseURL` is the endpoint for the local server.

- `models` is a map of model IDs to their configurations. The model name will be displayed in the model selection list.

---

### [IO.NET](#ionet)

IO.NET offers 17 models optimized for various use cases:

- Head over to the [IO.NET console](https://ai.io.net/), create an account, and generate an API key.

- Run the `/connect` command and search for **IO.NET**. ```txt /connect ```

- Enter your IO.NET API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [LM Studio](#lm-studio)

You can configure opencode to use local models through LM Studio.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio (local)",
      "options": {
        "baseURL": "http://127.0.0.1:1234/v1"
      },
      "models": {
        "google/gemma-3n-e4b": {
          "name": "Gemma 3n-e4b (local)"
        }
      }
    }
  }
}
```

In this example:

- `lmstudio` is the custom provider ID. This can be any string you want.

- `npm` specifies the package to use for this provider. Here, `@ai-sdk/openai-compatible` is used for any OpenAI-compatible API.

- `name` is the display name for the provider in the UI.

- `options.baseURL` is the endpoint for the local server.

- `models` is a map of model IDs to their configurations. The model name will be displayed in the model selection list.

---

### [Moonshot AI](#moonshot-ai)

To use Kimi K2 from Moonshot AI:

- Head over to the [Moonshot AI console](https://platform.moonshot.ai/console), create an account, and click **Create API key**.

- Run the `/connect` command and search for **Moonshot AI**. ```txt /connect ```

- Enter your Moonshot API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select *Kimi K2*. ```txt /models ```

---

### [MiniMax](#minimax)

- Head over to the [MiniMax API Console](https://platform.minimax.io/login), create an account, and generate an API key.

- Run the `/connect` command and search for **MiniMax**. ```txt /connect ```

- Enter your MiniMax API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *M2.1*. ```txt /models ```

---

### [Nebius Token Factory](#nebius-token-factory)

- Head over to the [Nebius Token Factory console](https://tokenfactory.nebius.com/), create an account, and click **Add Key**.

- Run the `/connect` command and search for **Nebius Token Factory**. ```txt /connect ```

- Enter your Nebius Token Factory API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [Ollama](#ollama)

You can configure opencode to use local models through Ollama.

> **Tip:** Ollama can automatically configure itself for OpenCode. See the [Ollama integration docs](https://docs.ollama.com/integrations/opencode) for details.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "llama2": {
          "name": "Llama 2"
        }
      }
    }
  }
}
```

In this example:

- `ollama` is the custom provider ID. This can be any string you want.

- `npm` specifies the package to use for this provider. Here, `@ai-sdk/openai-compatible` is used for any OpenAI-compatible API.

- `name` is the display name for the provider in the UI.

- `options.baseURL` is the endpoint for the local server.

- `models` is a map of model IDs to their configurations. The model name will be displayed in the model selection list.

> **Tip:** If tool calls aren’t working, try increasing `num_ctx` in Ollama. Start around 16k - 32k.

---

### [Ollama Cloud](#ollama-cloud)

To use Ollama Cloud with OpenCode:

- Head over to [https://ollama.com/](https://ollama.com/) and sign in or create an account.

- Navigate to **Settings** > **Keys** and click **Add API Key** to generate a new API key.

- Copy the API key for use in OpenCode.

- Run the `/connect` command and search for **Ollama Cloud**. ```txt /connect ```

- Enter your Ollama Cloud API key. ```txt ┌ API key │ │ └ enter ```

- **Important**: Before using cloud models in OpenCode, you must pull the model information locally: ```bash ollama pull gpt-oss:20b-cloud ```

- Run the `/models` command to select your Ollama Cloud model. ```txt /models ```

---

### [OpenAI](#openai)

We recommend signing up for [ChatGPT Plus or Pro](https://chatgpt.com/pricing).

- Once you’ve signed up, run the `/connect` command and select OpenAI. ```txt /connect ```

- Here you can select the **ChatGPT Plus/Pro** option and it’ll open your browser and ask you to authenticate. ```txt ┌ Select auth method │ │ ChatGPT Plus/Pro │ Manually enter API Key └ ```

- Now all the OpenAI models should be available when you use the `/models` command. ```txt /models ```

##### [Using API keys](#using-api-keys)

If you already have an API key, you can select **Manually enter API Key** and paste it in your terminal.

---

### [OpenCode Zen](#opencode-zen-1)

OpenCode Zen is a list of tested and verified models provided by the OpenCode team. [Learn more](/docs/zen).

- Sign in to **[OpenCode Zen](https://opencode.ai/auth)** and click **Create API Key**.

- Run the `/connect` command and search for **OpenCode Zen**. ```txt /connect ```

- Enter your OpenCode API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Qwen 3 Coder 480B*. ```txt /models ```

---

### [OpenRouter](#openrouter)

- Head over to the [OpenRouter dashboard](https://openrouter.ai/settings/keys), click **Create API Key**, and copy the key.

- Run the `/connect` command and search for OpenRouter. ```txt /connect ```

- Enter the API key for the provider. ```txt ┌ API key │ │ └ enter ```

- Many OpenRouter models are preloaded by default, run the `/models` command to select the one you want. ```txt /models ``` You can also add additional models through your opencode config. // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "openrouter": { "models": { "somecoolnewmodel": {} } } } } ```

- You can also customize them through your opencode config. Here’s an example of specifying a provider // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "openrouter": { "models": { "moonshotai/kimi-k2": { "options": { "provider": { "order": ["baseten"], "allow_fallbacks": false } } } } } } } ```

---

### [SAP AI Core](#sap-ai-core)

SAP AI Core provides access to 40+ models from OpenAI, Anthropic, Google, Amazon, Meta, Mistral, and AI21 through a unified platform.

- Go to your [SAP BTP Cockpit](https://account.hana.ondemand.com/), navigate to your SAP AI Core service instance, and create a service key. > **Tip:** The service key is a JSON object containing `clientid`, `clientsecret`, `url`, and `serviceurls.AI_API_URL`. You can find your AI Core instance under **Services** > **Instances and Subscriptions** in the BTP Cockpit.

- Run the `/connect` command and search for **SAP AI Core**. ```txt /connect ```

- Enter your service key JSON. ```txt ┌ Service key │ │ └ enter ``` Or set the `AICORE_SERVICE_KEY` environment variable: ```bash AICORE_SERVICE_KEY='{"clientid":"...","clientsecret":"...","url":"...","serviceurls":{"AI_API_URL":"..."}}' opencode ``` Or add it to your bash profile: // ~/.bash_profile ```bash export AICORE_SERVICE_KEY='{"clientid":"...","clientsecret":"...","url":"...","serviceurls":{"AI_API_URL":"..."}}' ```

- Optionally set deployment ID and resource group: ```bash AICORE_DEPLOYMENT_ID=your-deployment-id AICORE_RESOURCE_GROUP=your-resource-group opencode ``` > **Note:** These settings are optional and should be configured according to your SAP AI Core setup.

- Run the `/models` command to select from 40+ available models. ```txt /models ```

---

### [STACKIT](#stackit)

STACKIT AI Model Serving provides fully managed soverign hosting environment for AI models, focusing on LLMs like Llama, Mistral, and Qwen, with maximum data sovereignty on European infrastructure.

- Head over to [STACKIT Portal](https://portal.stackit.cloud), navigate to **AI Model Serving**, and create an auth token for your project. > **Tip:** You need a STACKIT customer account, user account, and project before creating auth tokens.

- Run the `/connect` command and search for **STACKIT**. ```txt /connect ```

- Enter your STACKIT AI Model Serving auth token. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select from available models like *Qwen3-VL 235B* or *Llama 3.3 70B*. ```txt /models ```

---

### [OVHcloud AI Endpoints](#ovhcloud-ai-endpoints)

- Head over to the [OVHcloud panel](https://ovh.com/manager). Navigate to the `Public Cloud` section, `AI & Machine Learning` > `AI Endpoints` and in `API Keys` tab, click **Create a new API key**.

- Run the `/connect` command and search for **OVHcloud AI Endpoints**. ```txt /connect ```

- Enter your OVHcloud AI Endpoints API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *gpt-oss-120b*. ```txt /models ```

---

### [Scaleway](#scaleway)

To use [Scaleway Generative APIs](https://www.scaleway.com/en/docs/generative-apis/) with Opencode:

- Head over to the [Scaleway Console IAM settings](https://console.scaleway.com/iam/api-keys) to generate a new API key.

- Run the `/connect` command and search for **Scaleway**. ```txt /connect ```

- Enter your Scaleway API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *devstral-2-123b-instruct-2512* or *gpt-oss-120b*. ```txt /models ```

---

### [Together AI](#together-ai)

- Head over to the [Together AI console](https://api.together.ai), create an account, and click **Add Key**.

- Run the `/connect` command and search for **Together AI**. ```txt /connect ```

- Enter your Together AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [Venice AI](#venice-ai)

- Head over to the [Venice AI console](https://venice.ai), create an account, and generate an API key.

- Run the `/connect` command and search for **Venice AI**. ```txt /connect ```

- Enter your Venice AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Llama 3.3 70B*. ```txt /models ```

---

### [Vercel AI Gateway](#vercel-ai-gateway)

Vercel AI Gateway lets you access models from OpenAI, Anthropic, Google, xAI, and more through a unified endpoint. Models are offered at list price with no markup.

- Head over to the [Vercel dashboard](https://vercel.com/), navigate to the **AI Gateway** tab, and click **API keys** to create a new API key.

- Run the `/connect` command and search for **Vercel AI Gateway**. ```txt /connect ```

- Enter your Vercel AI Gateway API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

You can also customize models through your opencode config. Here’s an example of specifying provider routing order.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "vercel": {
      "models": {
        "anthropic/claude-sonnet-4": {
          "options": {
            "order": ["anthropic", "vertex"]
          }
        }
      }
    }
  }
}
```

Some useful routing options:

OptionDescriptionorderProvider sequence to tryonlyRestrict to specific providerszeroDataRetentionOnly use providers with zero data retention policies

---

### [xAI](#xai)

- Head over to the [xAI console](https://console.x.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **xAI**. ```txt /connect ```

- Enter your xAI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Grok Beta*. ```txt /models ```

---

### [Z.AI](#zai)

- Head over to the [Z.AI API console](https://z.ai/manage-apikey/apikey-list), create an account, and click **Create a new API key**.

- Run the `/connect` command and search for **Z.AI**. ```txt /connect ``` If you are subscribed to the **GLM Coding Plan**, select **Z.AI Coding Plan**.

- Enter your Z.AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *GLM-4.7*. ```txt /models ```

---

### [ZenMux](#zenmux)

- Head over to the [ZenMux dashboard](https://zenmux.ai/settings/keys), click **Create API Key**, and copy the key.

- Run the `/connect` command and search for ZenMux. ```txt /connect ```

- Enter the API key for the provider. ```txt ┌ API key │ │ └ enter ```

- Many ZenMux models are preloaded by default, run the `/models` command to select the one you want. ```txt /models ``` You can also add additional models through your opencode config. // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "zenmux": { "models": { "somecoolnewmodel": {} } } } } ```

---

## [Custom provider](#custom-provider)

To add any **OpenAI-compatible** provider that’s not listed in the `/connect` command:

> **Tip:** You can use any OpenAI-compatible provider with opencode. Most modern AI providers offer OpenAI-compatible APIs.

- Run the `/connect` command and scroll down to **Other**. ```bash $ /connect ┌ Add credential │ ◆ Select provider │ ... │ ● Other └ ```

- Enter a unique ID for the provider. ```bash $ /connect ┌ Add credential │ ◇ Enter provider id │ myprovider └ ``` > **Note:** Choose a memorable ID, you’ll use this in your config file.

- Enter your API key for the provider. ```bash $ /connect ┌ Add credential │ ▲ This only stores a credential for myprovider - you will need to configure it in opencode.json, check the docs for examples. │ ◇ Enter your API key │ sk-... └ ```

- Create or update your `opencode.json` file in your project directory: // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "myprovider": { "npm": "@ai-sdk/openai-compatible", "name": "My AI ProviderDisplay Name", "options": { "baseURL": "https://api.myprovider.com/v1" }, "models": { "my-model-name": { "name": "My Model Display Name" } } } } } ``` Here are the configuration options: **npm**: AI SDK package to use, `@ai-sdk/openai-compatible` for OpenAI-compatible providers (for `/v1/chat/completions`). If your provider/model uses `/v1/responses`, use `@ai-sdk/openai`.

- **name**: Display name in UI.

- **models**: Available models.

- **options.baseURL**: API endpoint URL.

- **options.apiKey**: Optionally set the API key, if not using auth.

- **options.headers**: Optionally set custom headers.

More on the advanced options in the example below.

- Run the `/models` command and your custom provider and models will appear in the selection list.

---

##### [Example](#example)

Here’s an example setting the `apiKey`, `headers`, and model `limit` options.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "myprovider": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "My AI ProviderDisplay Name",
      "options": {
        "baseURL": "https://api.myprovider.com/v1",
        "apiKey": "{env:ANTHROPIC_API_KEY}",
        "headers": {
          "Authorization": "Bearer custom-token"
        }
      },
      "models": {
        "my-model-name": {
          "name": "My Model Display Name",
          "limit": {
            "context": 200000,
            "output": 65536
          }
        }
      }
    }
  }
}
```

Configuration details:

- **apiKey**: Set using `env` variable syntax, [learn more](/docs/config#env-vars).

- **headers**: Custom headers sent with each request.

- **limit.context**: Maximum input tokens the model accepts.

- **limit.output**: Maximum tokens the model can generate.

The `limit` fields allow OpenCode to understand how much context you have left. Standard providers pull these from models.dev automatically.

---

## [Troubleshooting](#troubleshooting)

If you are having trouble with configuring a provider, check the following:

- **Check the auth setup**: Run `opencode auth list` to see if the credentials for the provider are added to your config. This doesn’t apply to providers like Amazon Bedrock, that rely on environment variables for their auth.

- For custom providers, check the opencode config and: Make sure the provider ID used in the `/connect` command matches the ID in your opencode config.

- The right npm package is used for the provider. For example, use `@ai-sdk/cerebras` for Cerebras. And for all other OpenAI-compatible providers, use `@ai-sdk/openai-compatible` (for `/v1/chat/completions`); if a model uses `/v1/responses`, use `@ai-sdk/openai`. For mixed setups under one provider, you can override per model via `provider.npm`.

- Check correct API endpoint is used in the `options.baseURL` field.


---
# File: providers.md
---
title: "Providers"
source: "https://opencode.ai/docs/providers/"
description: "Using any LLM provider in OpenCode."
---

OpenCode uses the [AI SDK](https://ai-sdk.dev/) and [Models.dev](https://models.dev) to support **75+ LLM providers** and it supports running local models.

To add a provider you need to:

- Add the API keys for the provider using the `/connect` command.

- Configure the provider in your OpenCode config.

---

### [Credentials](#credentials)

When you add a provider’s API keys with the `/connect` command, they are stored in `~/.local/share/opencode/auth.json`.

---

### [Config](#config)

You can customize the providers through the `provider` section in your OpenCode config.

---

#### [Base URL](#base-url)

You can customize the base URL for any provider by setting the `baseURL` option. This is useful when using proxy services or custom endpoints.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "anthropic": {
      "options": {
        "baseURL": "https://api.anthropic.com/v1"
      }
    }
  }
}
```

---

## [OpenCode Zen](#opencode-zen)

OpenCode Zen is a list of models provided by the OpenCode team that have been tested and verified to work well with OpenCode. [Learn more](/docs/zen).

> **Tip:** If you are new, we recommend starting with OpenCode Zen.

- Run the `/connect` command in the TUI, select `OpenCode Zen`, and head to [opencode.ai/auth](https://opencode.ai/zen). ```txt /connect ```

- Sign in, add your billing details, and copy your API key.

- Paste your API key. ```txt ┌ API key │ │ └ enter ```

- Run `/models` in the TUI to see the list of models we recommend. ```txt /models ```

It works like any other provider in OpenCode and is completely optional to use.

---

## [OpenCode Go](#opencode-go)

OpenCode Go is a low cost subscription plan that provides reliable access to popular open coding models provided by the OpenCode team that have been tested and verified to work well with OpenCode.

- Run the `/connect` command in the TUI, select `OpenCode Go`, and head to [opencode.ai/auth](https://opencode.ai/zen). ```txt /connect ```

- Sign in, add your billing details, and copy your API key.

- Paste your API key. ```txt ┌ API key │ │ └ enter ```

- Run `/models` in the TUI to see the list of models we recommend. ```txt /models ```

It works like any other provider in OpenCode and is completely optional to use.

---

## [Directory](#directory)

Let’s look at some of the providers in detail. If you’d like to add a provider to the list, feel free to open a PR.

> **Note:** Don’t see a provider here? Submit a PR.

---

### [302.AI](#302ai)

- Head over to the [302.AI console](https://302.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **302.AI**. ```txt /connect ```

- Enter your 302.AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Amazon Bedrock](#amazon-bedrock)

To use Amazon Bedrock with OpenCode:

- Head over to the **Model catalog** in the Amazon Bedrock console and request access to the models you want. > **Tip:** You need to have access to the model you want in Amazon Bedrock.

- **Configure authentication** using one of the following methods: --- #### [Environment Variables (Quick Start)](#environment-variables-quick-start) Set one of these environment variables while running opencode: ```bash # Option 1: Using AWS access keys AWS_ACCESS_KEY_ID=XXX AWS_SECRET_ACCESS_KEY=YYY opencode # Option 2: Using named AWS profile AWS_PROFILE=my-profile opencode # Option 3: Using Bedrock bearer token AWS_BEARER_TOKEN_BEDROCK=XXX opencode ``` Or add them to your bash profile: // ~/.bash_profile ```bash export AWS_PROFILE=my-dev-profile export AWS_REGION=us-east-1 ``` --- #### [Configuration File (Recommended)](#configuration-file-recommended) For project-specific or persistent configuration, use `opencode.json`: // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "amazon-bedrock": { "options": { "region": "us-east-1", "profile": "my-aws-profile" } } } } ``` **Available options:** `region` - AWS region (e.g., `us-east-1`, `eu-west-1`)

- `profile` - AWS named profile from `~/.aws/credentials`

- `endpoint` - Custom endpoint URL for VPC endpoints (alias for generic `baseURL` option)

> **Tip:** Configuration file options take precedence over environment variables.

---

#### [Advanced: VPC Endpoints](#advanced-vpc-endpoints)

If you’re using VPC endpoints for Bedrock:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "amazon-bedrock": {
      "options": {
        "region": "us-east-1",
        "profile": "production",
        "endpoint": "https://bedrock-runtime.us-east-1.vpce-xxxxx.amazonaws.com"
      }
    }
  }
}
```

> **Note:** The `endpoint` option is an alias for the generic `baseURL` option, using AWS-specific terminology. If both `endpoint` and `baseURL` are specified, `endpoint` takes precedence.

---

#### [Authentication Methods](#authentication-methods)

- **`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`**: Create an IAM user and generate access keys in the AWS Console

- **`AWS_PROFILE`**: Use named profiles from `~/.aws/credentials`. First configure with `aws configure --profile my-profile` or `aws sso login`

- **`AWS_BEARER_TOKEN_BEDROCK`**: Generate long-term API keys from the Amazon Bedrock console

- **`AWS_WEB_IDENTITY_TOKEN_FILE` / `AWS_ROLE_ARN`**: For EKS IRSA (IAM Roles for Service Accounts) or other Kubernetes environments with OIDC federation. These environment variables are automatically injected by Kubernetes when using service account annotations.

---

#### [Authentication Precedence](#authentication-precedence)

Amazon Bedrock uses the following authentication priority:

- **Bearer Token** - `AWS_BEARER_TOKEN_BEDROCK` environment variable or token from `/connect` command

- **AWS Credential Chain** - Profile, access keys, shared credentials, IAM roles, Web Identity Tokens (EKS IRSA), instance metadata

> **Note:** When a bearer token is set (via `/connect` or `AWS_BEARER_TOKEN_BEDROCK`), it takes precedence over all AWS credential methods including configured profiles.

- Run the `/models` command to select the model you want. ```txt /models ```

> **Note:** For custom inference profiles, use the model and provider name in the key and set the `id` property to the arn. This ensures correct caching.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "amazon-bedrock": {
      // ...
      "models": {
        "anthropic-claude-sonnet-4.5": {
          "id": "arn:aws:bedrock:us-east-1:xxx:application-inference-profile/yyy"
        }
      }
    }
  }
}
```

---

### [Anthropic](#anthropic)

- Once you’ve signed up, run the `/connect` command and select Anthropic. ```txt /connect ```

- Here you can select the **Claude Pro/Max** option and it’ll open your browser and ask you to authenticate. ```txt ┌ Select auth method │ │ Manually enter API Key └ ```

- Now all the Anthropic models should be available when you use the `/models` command. ```txt /models ```

There are plugins that allow you to use your Claude Pro/Max models with OpenCode. Anthropic explicitly prohibits this.

Previous versions of OpenCode came bundled with these plugins but that is no longer the case as of 1.3.0

Other companies support freedom of choice with developer tooling - you can use the following subscriptions in OpenCode with zero setup:

- ChatGPT Plus

- Github Copilot

- Gitlab Duo

---

### [Azure OpenAI](#azure-openai)

> **Note:** If you encounter “I’m sorry, but I cannot assist with that request” errors, try changing the content filter from **DefaultV2** to **Default** in your Azure resource.

- Head over to the [Azure portal](https://portal.azure.com/) and create an **Azure OpenAI** resource. You’ll need: **Resource name**: This becomes part of your API endpoint (`https://RESOURCE_NAME.openai.azure.com/`)

- **API key**: Either `KEY 1` or `KEY 2` from your resource

- Go to [Azure AI Foundry](https://ai.azure.com/) and deploy a model. > **Note:** The deployment name must match the model name for opencode to work properly.

- Run the `/connect` command and search for **Azure**. ```txt /connect ```

- Enter your API key. ```txt ┌ API key │ │ └ enter ```

- Set your resource name as an environment variable: ```bash AZURE_RESOURCE_NAME=XXX opencode ``` Or add it to your bash profile: // ~/.bash_profile ```bash export AZURE_RESOURCE_NAME=XXX ```

- Run the `/models` command to select your deployed model. ```txt /models ```

---

### [Azure Cognitive Services](#azure-cognitive-services)

- Head over to the [Azure portal](https://portal.azure.com/) and create an **Azure OpenAI** resource. You’ll need: **Resource name**: This becomes part of your API endpoint (`https://AZURE_COGNITIVE_SERVICES_RESOURCE_NAME.cognitiveservices.azure.com/`)

- **API key**: Either `KEY 1` or `KEY 2` from your resource

- Go to [Azure AI Foundry](https://ai.azure.com/) and deploy a model. > **Note:** The deployment name must match the model name for opencode to work properly.

- Run the `/connect` command and search for **Azure Cognitive Services**. ```txt /connect ```

- Enter your API key. ```txt ┌ API key │ │ └ enter ```

- Set your resource name as an environment variable: ```bash AZURE_COGNITIVE_SERVICES_RESOURCE_NAME=XXX opencode ``` Or add it to your bash profile: // ~/.bash_profile ```bash export AZURE_COGNITIVE_SERVICES_RESOURCE_NAME=XXX ```

- Run the `/models` command to select your deployed model. ```txt /models ```

---

### [Baseten](#baseten)

- Head over to the [Baseten](https://app.baseten.co/), create an account, and generate an API key.

- Run the `/connect` command and search for **Baseten**. ```txt /connect ```

- Enter your Baseten API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Cerebras](#cerebras)

- Head over to the [Cerebras console](https://inference.cerebras.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **Cerebras**. ```txt /connect ```

- Enter your Cerebras API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Qwen 3 Coder 480B*. ```txt /models ```

---

### [Cloudflare AI Gateway](#cloudflare-ai-gateway)

Cloudflare AI Gateway lets you access models from OpenAI, Anthropic, Workers AI, and more through a unified endpoint. With [Unified Billing](https://developers.cloudflare.com/ai-gateway/features/unified-billing/) you don’t need separate API keys for each provider.

- Head over to the [Cloudflare dashboard](https://dash.cloudflare.com/), navigate to **AI** > **AI Gateway**, and create a new gateway.

- Set your Account ID and Gateway ID as environment variables. // ~/.bash_profile ```bash export CLOUDFLARE_ACCOUNT_ID=your-32-character-account-id export CLOUDFLARE_GATEWAY_ID=your-gateway-id ```

- Run the `/connect` command and search for **Cloudflare AI Gateway**. ```txt /connect ```

- Enter your Cloudflare API token. ```txt ┌ API key │ │ └ enter ``` Or set it as an environment variable. // ~/.bash_profile ```bash export CLOUDFLARE_API_TOKEN=your-api-token ```

- Run the `/models` command to select a model. ```txt /models ``` You can also add models through your opencode config. // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "cloudflare-ai-gateway": { "models": { "openai/gpt-4o": {}, "anthropic/claude-sonnet-4": {} } } } } ```

---

### [Cloudflare Workers AI](#cloudflare-workers-ai)

Cloudflare Workers AI lets you run AI models on Cloudflare’s global network directly via REST API, with no separate provider accounts needed for supported models.

- Head over to the [Cloudflare dashboard](https://dash.cloudflare.com/), navigate to **Workers AI**, and select **Use REST API** to get your Account ID and create an API token.

- Set your Account ID as an environment variable. // ~/.bash_profile ```bash export CLOUDFLARE_ACCOUNT_ID=your-32-character-account-id ```

- Run the `/connect` command and search for **Cloudflare Workers AI**. ```txt /connect ```

- Enter your Cloudflare API token. ```txt ┌ API key │ │ └ enter ``` Or set it as an environment variable. // ~/.bash_profile ```bash export CLOUDFLARE_API_KEY=your-api-token ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Cortecs](#cortecs)

- Head over to the [Cortecs console](https://cortecs.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **Cortecs**. ```txt /connect ```

- Enter your Cortecs API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [DeepSeek](#deepseek)

- Head over to the [DeepSeek console](https://platform.deepseek.com/), create an account, and click **Create new API key**.

- Run the `/connect` command and search for **DeepSeek**. ```txt /connect ```

- Enter your DeepSeek API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a DeepSeek model like *DeepSeek Reasoner*. ```txt /models ```

---

### [Deep Infra](#deep-infra)

- Head over to the [Deep Infra dashboard](https://deepinfra.com/dash), create an account, and generate an API key.

- Run the `/connect` command and search for **Deep Infra**. ```txt /connect ```

- Enter your Deep Infra API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Firmware](#firmware)

- Head over to the [Firmware dashboard](https://app.firmware.ai/signup), create an account, and generate an API key.

- Run the `/connect` command and search for **Firmware**. ```txt /connect ```

- Enter your Firmware API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [Fireworks AI](#fireworks-ai)

- Head over to the [Fireworks AI console](https://app.fireworks.ai/), create an account, and click **Create API Key**.

- Run the `/connect` command and search for **Fireworks AI**. ```txt /connect ```

- Enter your Fireworks AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [GitLab Duo](#gitlab-duo)

> **Caution:** GitLab Duo support in OpenCode is experimental. Features, configuration, and behavior may change in future releases.

OpenCode integrates with the [GitLab Duo Agent Platform](https://docs.gitlab.com/user/duo_agent_platform/), providing AI-powered agentic chat with native tool calling capabilities.

> **Note:** GitLab Duo Agent Platform requires a **Premium** or **Ultimate** GitLab subscription. It is available on GitLab.com and GitLab Self-Managed. See [GitLab Duo Agent Platform prerequisites](https://docs.gitlab.com/user/duo_agent_platform/#prerequisites) for full requirements.

- Run the `/connect` command and select GitLab. ```txt /connect ```

- Choose your authentication method: ```txt ┌ Select auth method │ │ OAuth (Recommended) │ Personal Access Token └ ``` #### [Using OAuth (Recommended)](#using-oauth-recommended) Select **OAuth** and your browser will open for authorization. #### [Using Personal Access Token](#using-personal-access-token) Go to [GitLab User Settings > Access Tokens](https://gitlab.com/-/user_settings/personal_access_tokens)

- Click **Add new token**

- Name: `OpenCode`, Scopes: `api`

- Copy the token (starts with `glpat-`)

- Enter it in the terminal

- Run the `/models` command to see available models. ```txt /models ``` Three Claude-based models are available: **duo-chat-haiku-4-5** (Default) - Fast responses for quick tasks

- **duo-chat-sonnet-4-5** - Balanced performance for most workflows

- **duo-chat-opus-4-5** - Most capable for complex analysis

> **Note:** You can also specify ‘GITLAB_TOKEN’ environment variable if you don’t want to store token in opencode auth storage.

##### [Self-Hosted GitLab](#self-hosted-gitlab)

> **Note:** OpenCode uses a small model for some AI tasks like generating the session title. It is configured to use gpt-5-nano by default, hosted by Zen. To lock OpenCode to only use your own GitLab-hosted instance, add the following to your `opencode.json` file. It is also recommended to disable session sharing.

For self-hosted GitLab instances:

```bash
export GITLAB_INSTANCE_URL=https://gitlab.company.com
export GITLAB_TOKEN=glpat-...
```

If your instance runs a custom AI Gateway:

```bash
GITLAB_AI_GATEWAY_URL=https://ai-gateway.company.com
```

Or add to your bash profile:

// ~/.bash_profile
```bash
export GITLAB_INSTANCE_URL=https://gitlab.company.com
export GITLAB_AI_GATEWAY_URL=https://ai-gateway.company.com
export GITLAB_TOKEN=glpat-...
```

> **Note:** Your GitLab administrator must:

##### [OAuth for Self-Hosted instances](#oauth-for-self-hosted-instances)

In order to make Oauth working for your self-hosted instance, you need to create a new application (Settings → Applications) with the callback URL `http://127.0.0.1:8080/callback` and following scopes:

- api (Access the API on your behalf)

- read_user (Read your personal information)

- read_repository (Allows read-only access to the repository)

Then expose application ID as environment variable:

```bash
export GITLAB_OAUTH_CLIENT_ID=your_application_id_here
```

More documentation on [opencode-gitlab-auth](https://www.npmjs.com/package/opencode-gitlab-auth) homepage.

##### [Configuration](#configuration)

Customize through `opencode.json`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "gitlab": {
      "options": {
        "instanceUrl": "https://gitlab.com"
      }
    }
  }
}
```

##### [GitLab Duo Agent Platform (DAP) Workflow Models](#gitlab-duo-agent-platform-dap-workflow-models)

DAP workflow models provide an alternative execution path that routes tool calls through GitLab’s Duo Workflow Service (DWS) instead of the standard agentic chat. When a `duo-workflow-*` model is selected, OpenCode will:

- Discover available models from your GitLab namespace

- Present a selection picker if multiple models are available

- Cache the selected model to disk for fast subsequent startups

- Route tool execution requests through OpenCode’s permission-gated tool system

Available DAP workflow models follow the `duo-workflow-*` naming convention and are dynamically discovered from your GitLab instance.

##### [GitLab API Tools (Optional, but highly recommended)](#gitlab-api-tools-optional-but-highly-recommended)

To access GitLab tools (merge requests, issues, pipelines, CI/CD, etc.):

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-gitlab-plugin"]
}
```

This plugin provides comprehensive GitLab repository management capabilities including MR reviews, issue tracking, pipeline monitoring, and more.

---

### [GitHub Copilot](#github-copilot)

To use your GitHub Copilot subscription with opencode:

> **Note:** Some models might need a [Pro+ subscription](https://github.com/features/copilot/plans) to use.

- Run the `/connect` command and search for GitHub Copilot. ```txt /connect ```

- Navigate to [github.com/login/device](https://github.com/login/device) and enter the code. ```txt ┌ Login with GitHub Copilot │ │ https://github.com/login/device │ │ Enter code: 8F43-6FCF │ └ Waiting for authorization... ```

- Now run the `/models` command to select the model you want. ```txt /models ```

---

### [Google Vertex AI](#google-vertex-ai)

To use Google Vertex AI with OpenCode:

- Head over to the **Model Garden** in the Google Cloud Console and check the models available in your region. > **Note:** You need to have a Google Cloud project with Vertex AI API enabled.

- Set the required environment variables: `GOOGLE_CLOUD_PROJECT`: Your Google Cloud project ID

- `VERTEX_LOCATION` (optional): The region for Vertex AI (defaults to `global`)

- Authentication (choose one): `GOOGLE_APPLICATION_CREDENTIALS`: Path to your service account JSON key file

- Authenticate using gcloud CLI: `gcloud auth application-default login`

Set them while running opencode.

```bash
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json GOOGLE_CLOUD_PROJECT=your-project-id opencode
```

Or add them to your bash profile.

// ~/.bash_profile
```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
export GOOGLE_CLOUD_PROJECT=your-project-id
export VERTEX_LOCATION=global
```

> **Tip:** The `global` region improves availability and reduces errors at no extra cost. Use regional endpoints (e.g., `us-central1`) for data residency requirements. [Learn more](https://cloud.google.com/vertex-ai/generative-ai/docs/partner-models/use-partner-models#regional_and_global_endpoints)

- Run the `/models` command to select the model you want. ```txt /models ```

---

### [Groq](#groq)

- Head over to the [Groq console](https://console.groq.com/), click **Create API Key**, and copy the key.

- Run the `/connect` command and search for Groq. ```txt /connect ```

- Enter the API key for the provider. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select the one you want. ```txt /models ```

---

### [Hugging Face](#hugging-face)

[Hugging Face Inference Providers](https://huggingface.co/docs/inference-providers) provides access to open models supported by 17+ providers.

- Head over to [Hugging Face settings](https://huggingface.co/settings/tokens/new?ownUserPermissions=inference.serverless.write&tokenType=fineGrained) to create a token with permission to make calls to Inference Providers.

- Run the `/connect` command and search for **Hugging Face**. ```txt /connect ```

- Enter your Hugging Face token. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi-K2-Instruct* or *GLM-4.6*. ```txt /models ```

---

### [Helicone](#helicone)

[Helicone](https://helicone.ai) is an LLM observability platform that provides logging, monitoring, and analytics for your AI applications. The Helicone AI Gateway routes your requests to the appropriate provider automatically based on the model.

- Head over to [Helicone](https://helicone.ai), create an account, and generate an API key from your dashboard.

- Run the `/connect` command and search for **Helicone**. ```txt /connect ```

- Enter your Helicone API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

For more providers and advanced features like caching and rate limiting, check the [Helicone documentation](https://docs.helicone.ai).

#### [Optional Configs](#optional-configs)

In the event you see a feature or model from Helicone that isn’t configured automatically through opencode, you can always configure it yourself.

Here’s [Helicone’s Model Directory](https://helicone.ai/models), you’ll need this to grab the IDs of the models you want to add.

// ~/.config/opencode/opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "helicone": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Helicone",
      "options": {
        "baseURL": "https://ai-gateway.helicone.ai",
      },
      "models": {
        "gpt-4o": {
          // Model ID (from Helicone's model directory page)
          "name": "GPT-4o", // Your own custom name for the model
        },
        "claude-sonnet-4-20250514": {
          "name": "Claude Sonnet 4",
        },
      },
    },
  },
}
```

#### [Custom Headers](#custom-headers)

Helicone supports custom headers for features like caching, user tracking, and session management. Add them to your provider config using `options.headers`:

// ~/.config/opencode/opencode.jsonc
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "helicone": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Helicone",
      "options": {
        "baseURL": "https://ai-gateway.helicone.ai",
        "headers": {
          "Helicone-Cache-Enabled": "true",
          "Helicone-User-Id": "opencode",
        },
      },
    },
  },
}
```

##### [Session tracking](#session-tracking)

Helicone’s [Sessions](https://docs.helicone.ai/features/sessions) feature lets you group related LLM requests together. Use the [opencode-helicone-session](https://github.com/H2Shami/opencode-helicone-session) plugin to automatically log each OpenCode conversation as a session in Helicone.

```bash
npm install -g opencode-helicone-session
```

Add it to your config.

// opencode.json
```json
{
  "plugin": ["opencode-helicone-session"]
}
```

The plugin injects `Helicone-Session-Id` and `Helicone-Session-Name` headers into your requests. In Helicone’s Sessions page, you’ll see each OpenCode conversation listed as a separate session.

##### [Common Helicone headers](#common-helicone-headers)

HeaderDescriptionHelicone-Cache-EnabledEnable response caching (true/false)Helicone-User-IdTrack metrics by userHelicone-Property-[Name]Add custom properties (e.g., Helicone-Property-Environment)Helicone-Prompt-IdAssociate requests with prompt versions

See the [Helicone Header Directory](https://docs.helicone.ai/helicone-headers/header-directory) for all available headers.

---

### [llama.cpp](#llamacpp)

You can configure opencode to use local models through [llama.cpp’s](https://github.com/ggml-org/llama.cpp) llama-server utility

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "llama.cpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "llama-server (local)",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "qwen3-coder:a3b": {
          "name": "Qwen3-Coder: a3b-30b (local)",
          "limit": {
            "context": 128000,
            "output": 65536
          }
        }
      }
    }
  }
}
```

In this example:

- `llama.cpp` is the custom provider ID. This can be any string you want.

- `npm` specifies the package to use for this provider. Here, `@ai-sdk/openai-compatible` is used for any OpenAI-compatible API.

- `name` is the display name for the provider in the UI.

- `options.baseURL` is the endpoint for the local server.

- `models` is a map of model IDs to their configurations. The model name will be displayed in the model selection list.

---

### [IO.NET](#ionet)

IO.NET offers 17 models optimized for various use cases:

- Head over to the [IO.NET console](https://ai.io.net/), create an account, and generate an API key.

- Run the `/connect` command and search for **IO.NET**. ```txt /connect ```

- Enter your IO.NET API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

---

### [LM Studio](#lm-studio)

You can configure opencode to use local models through LM Studio.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio (local)",
      "options": {
        "baseURL": "http://127.0.0.1:1234/v1"
      },
      "models": {
        "google/gemma-3n-e4b": {
          "name": "Gemma 3n-e4b (local)"
        }
      }
    }
  }
}
```

In this example:

- `lmstudio` is the custom provider ID. This can be any string you want.

- `npm` specifies the package to use for this provider. Here, `@ai-sdk/openai-compatible` is used for any OpenAI-compatible API.

- `name` is the display name for the provider in the UI.

- `options.baseURL` is the endpoint for the local server.

- `models` is a map of model IDs to their configurations. The model name will be displayed in the model selection list.

---

### [Moonshot AI](#moonshot-ai)

To use Kimi K2 from Moonshot AI:

- Head over to the [Moonshot AI console](https://platform.moonshot.ai/console), create an account, and click **Create API key**.

- Run the `/connect` command and search for **Moonshot AI**. ```txt /connect ```

- Enter your Moonshot API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select *Kimi K2*. ```txt /models ```

---

### [MiniMax](#minimax)

- Head over to the [MiniMax API Console](https://platform.minimax.io/login), create an account, and generate an API key.

- Run the `/connect` command and search for **MiniMax**. ```txt /connect ```

- Enter your MiniMax API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *M2.1*. ```txt /models ```

---

### [Nebius Token Factory](#nebius-token-factory)

- Head over to the [Nebius Token Factory console](https://tokenfactory.nebius.com/), create an account, and click **Add Key**.

- Run the `/connect` command and search for **Nebius Token Factory**. ```txt /connect ```

- Enter your Nebius Token Factory API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [Ollama](#ollama)

You can configure opencode to use local models through Ollama.

> **Tip:** Ollama can automatically configure itself for OpenCode. See the [Ollama integration docs](https://docs.ollama.com/integrations/opencode) for details.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "llama2": {
          "name": "Llama 2"
        }
      }
    }
  }
}
```

In this example:

- `ollama` is the custom provider ID. This can be any string you want.

- `npm` specifies the package to use for this provider. Here, `@ai-sdk/openai-compatible` is used for any OpenAI-compatible API.

- `name` is the display name for the provider in the UI.

- `options.baseURL` is the endpoint for the local server.

- `models` is a map of model IDs to their configurations. The model name will be displayed in the model selection list.

> **Tip:** If tool calls aren’t working, try increasing `num_ctx` in Ollama. Start around 16k - 32k.

---

### [Ollama Cloud](#ollama-cloud)

To use Ollama Cloud with OpenCode:

- Head over to [https://ollama.com/](https://ollama.com/) and sign in or create an account.

- Navigate to **Settings** > **Keys** and click **Add API Key** to generate a new API key.

- Copy the API key for use in OpenCode.

- Run the `/connect` command and search for **Ollama Cloud**. ```txt /connect ```

- Enter your Ollama Cloud API key. ```txt ┌ API key │ │ └ enter ```

- **Important**: Before using cloud models in OpenCode, you must pull the model information locally: ```bash ollama pull gpt-oss:20b-cloud ```

- Run the `/models` command to select your Ollama Cloud model. ```txt /models ```

---

### [OpenAI](#openai)

We recommend signing up for [ChatGPT Plus or Pro](https://chatgpt.com/pricing).

- Once you’ve signed up, run the `/connect` command and select OpenAI. ```txt /connect ```

- Here you can select the **ChatGPT Plus/Pro** option and it’ll open your browser and ask you to authenticate. ```txt ┌ Select auth method │ │ ChatGPT Plus/Pro │ Manually enter API Key └ ```

- Now all the OpenAI models should be available when you use the `/models` command. ```txt /models ```

##### [Using API keys](#using-api-keys)

If you already have an API key, you can select **Manually enter API Key** and paste it in your terminal.

---

### [OpenCode Zen](#opencode-zen-1)

OpenCode Zen is a list of tested and verified models provided by the OpenCode team. [Learn more](/docs/zen).

- Sign in to **[OpenCode Zen](https://opencode.ai/auth)** and click **Create API Key**.

- Run the `/connect` command and search for **OpenCode Zen**. ```txt /connect ```

- Enter your OpenCode API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Qwen 3 Coder 480B*. ```txt /models ```

---

### [OpenRouter](#openrouter)

- Head over to the [OpenRouter dashboard](https://openrouter.ai/settings/keys), click **Create API Key**, and copy the key.

- Run the `/connect` command and search for OpenRouter. ```txt /connect ```

- Enter the API key for the provider. ```txt ┌ API key │ │ └ enter ```

- Many OpenRouter models are preloaded by default, run the `/models` command to select the one you want. ```txt /models ``` You can also add additional models through your opencode config. // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "openrouter": { "models": { "somecoolnewmodel": {} } } } } ```

- You can also customize them through your opencode config. Here’s an example of specifying a provider // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "openrouter": { "models": { "moonshotai/kimi-k2": { "options": { "provider": { "order": ["baseten"], "allow_fallbacks": false } } } } } } } ```

---

### [SAP AI Core](#sap-ai-core)

SAP AI Core provides access to 40+ models from OpenAI, Anthropic, Google, Amazon, Meta, Mistral, and AI21 through a unified platform.

- Go to your [SAP BTP Cockpit](https://account.hana.ondemand.com/), navigate to your SAP AI Core service instance, and create a service key. > **Tip:** The service key is a JSON object containing `clientid`, `clientsecret`, `url`, and `serviceurls.AI_API_URL`. You can find your AI Core instance under **Services** > **Instances and Subscriptions** in the BTP Cockpit.

- Run the `/connect` command and search for **SAP AI Core**. ```txt /connect ```

- Enter your service key JSON. ```txt ┌ Service key │ │ └ enter ``` Or set the `AICORE_SERVICE_KEY` environment variable: ```bash AICORE_SERVICE_KEY='{"clientid":"...","clientsecret":"...","url":"...","serviceurls":{"AI_API_URL":"..."}}' opencode ``` Or add it to your bash profile: // ~/.bash_profile ```bash export AICORE_SERVICE_KEY='{"clientid":"...","clientsecret":"...","url":"...","serviceurls":{"AI_API_URL":"..."}}' ```

- Optionally set deployment ID and resource group: ```bash AICORE_DEPLOYMENT_ID=your-deployment-id AICORE_RESOURCE_GROUP=your-resource-group opencode ``` > **Note:** These settings are optional and should be configured according to your SAP AI Core setup.

- Run the `/models` command to select from 40+ available models. ```txt /models ```

---

### [STACKIT](#stackit)

STACKIT AI Model Serving provides fully managed soverign hosting environment for AI models, focusing on LLMs like Llama, Mistral, and Qwen, with maximum data sovereignty on European infrastructure.

- Head over to [STACKIT Portal](https://portal.stackit.cloud), navigate to **AI Model Serving**, and create an auth token for your project. > **Tip:** You need a STACKIT customer account, user account, and project before creating auth tokens.

- Run the `/connect` command and search for **STACKIT**. ```txt /connect ```

- Enter your STACKIT AI Model Serving auth token. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select from available models like *Qwen3-VL 235B* or *Llama 3.3 70B*. ```txt /models ```

---

### [OVHcloud AI Endpoints](#ovhcloud-ai-endpoints)

- Head over to the [OVHcloud panel](https://ovh.com/manager). Navigate to the `Public Cloud` section, `AI & Machine Learning` > `AI Endpoints` and in `API Keys` tab, click **Create a new API key**.

- Run the `/connect` command and search for **OVHcloud AI Endpoints**. ```txt /connect ```

- Enter your OVHcloud AI Endpoints API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *gpt-oss-120b*. ```txt /models ```

---

### [Scaleway](#scaleway)

To use [Scaleway Generative APIs](https://www.scaleway.com/en/docs/generative-apis/) with Opencode:

- Head over to the [Scaleway Console IAM settings](https://console.scaleway.com/iam/api-keys) to generate a new API key.

- Run the `/connect` command and search for **Scaleway**. ```txt /connect ```

- Enter your Scaleway API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *devstral-2-123b-instruct-2512* or *gpt-oss-120b*. ```txt /models ```

---

### [Together AI](#together-ai)

- Head over to the [Together AI console](https://api.together.ai), create an account, and click **Add Key**.

- Run the `/connect` command and search for **Together AI**. ```txt /connect ```

- Enter your Together AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Kimi K2 Instruct*. ```txt /models ```

---

### [Venice AI](#venice-ai)

- Head over to the [Venice AI console](https://venice.ai), create an account, and generate an API key.

- Run the `/connect` command and search for **Venice AI**. ```txt /connect ```

- Enter your Venice AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Llama 3.3 70B*. ```txt /models ```

---

### [Vercel AI Gateway](#vercel-ai-gateway)

Vercel AI Gateway lets you access models from OpenAI, Anthropic, Google, xAI, and more through a unified endpoint. Models are offered at list price with no markup.

- Head over to the [Vercel dashboard](https://vercel.com/), navigate to the **AI Gateway** tab, and click **API keys** to create a new API key.

- Run the `/connect` command and search for **Vercel AI Gateway**. ```txt /connect ```

- Enter your Vercel AI Gateway API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model. ```txt /models ```

You can also customize models through your opencode config. Here’s an example of specifying provider routing order.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "vercel": {
      "models": {
        "anthropic/claude-sonnet-4": {
          "options": {
            "order": ["anthropic", "vertex"]
          }
        }
      }
    }
  }
}
```

Some useful routing options:

OptionDescriptionorderProvider sequence to tryonlyRestrict to specific providerszeroDataRetentionOnly use providers with zero data retention policies

---

### [xAI](#xai)

- Head over to the [xAI console](https://console.x.ai/), create an account, and generate an API key.

- Run the `/connect` command and search for **xAI**. ```txt /connect ```

- Enter your xAI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *Grok Beta*. ```txt /models ```

---

### [Z.AI](#zai)

- Head over to the [Z.AI API console](https://z.ai/manage-apikey/apikey-list), create an account, and click **Create a new API key**.

- Run the `/connect` command and search for **Z.AI**. ```txt /connect ``` If you are subscribed to the **GLM Coding Plan**, select **Z.AI Coding Plan**.

- Enter your Z.AI API key. ```txt ┌ API key │ │ └ enter ```

- Run the `/models` command to select a model like *GLM-4.7*. ```txt /models ```

---

### [ZenMux](#zenmux)

- Head over to the [ZenMux dashboard](https://zenmux.ai/settings/keys), click **Create API Key**, and copy the key.

- Run the `/connect` command and search for ZenMux. ```txt /connect ```

- Enter the API key for the provider. ```txt ┌ API key │ │ └ enter ```

- Many ZenMux models are preloaded by default, run the `/models` command to select the one you want. ```txt /models ``` You can also add additional models through your opencode config. // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "zenmux": { "models": { "somecoolnewmodel": {} } } } } ```

---

## [Custom provider](#custom-provider)

To add any **OpenAI-compatible** provider that’s not listed in the `/connect` command:

> **Tip:** You can use any OpenAI-compatible provider with opencode. Most modern AI providers offer OpenAI-compatible APIs.

- Run the `/connect` command and scroll down to **Other**. ```bash $ /connect ┌ Add credential │ ◆ Select provider │ ... │ ● Other └ ```

- Enter a unique ID for the provider. ```bash $ /connect ┌ Add credential │ ◇ Enter provider id │ myprovider └ ``` > **Note:** Choose a memorable ID, you’ll use this in your config file.

- Enter your API key for the provider. ```bash $ /connect ┌ Add credential │ ▲ This only stores a credential for myprovider - you will need to configure it in opencode.json, check the docs for examples. │ ◇ Enter your API key │ sk-... └ ```

- Create or update your `opencode.json` file in your project directory: // opencode.json ```json { "$schema": "https://opencode.ai/config.json", "provider": { "myprovider": { "npm": "@ai-sdk/openai-compatible", "name": "My AI ProviderDisplay Name", "options": { "baseURL": "https://api.myprovider.com/v1" }, "models": { "my-model-name": { "name": "My Model Display Name" } } } } } ``` Here are the configuration options: **npm**: AI SDK package to use, `@ai-sdk/openai-compatible` for OpenAI-compatible providers (for `/v1/chat/completions`). If your provider/model uses `/v1/responses`, use `@ai-sdk/openai`.

- **name**: Display name in UI.

- **models**: Available models.

- **options.baseURL**: API endpoint URL.

- **options.apiKey**: Optionally set the API key, if not using auth.

- **options.headers**: Optionally set custom headers.

More on the advanced options in the example below.

- Run the `/models` command and your custom provider and models will appear in the selection list.

---

##### [Example](#example)

Here’s an example setting the `apiKey`, `headers`, and model `limit` options.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "myprovider": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "My AI ProviderDisplay Name",
      "options": {
        "baseURL": "https://api.myprovider.com/v1",
        "apiKey": "{env:ANTHROPIC_API_KEY}",
        "headers": {
          "Authorization": "Bearer custom-token"
        }
      },
      "models": {
        "my-model-name": {
          "name": "My Model Display Name",
          "limit": {
            "context": 200000,
            "output": 65536
          }
        }
      }
    }
  }
}
```

Configuration details:

- **apiKey**: Set using `env` variable syntax, [learn more](/docs/config#env-vars).

- **headers**: Custom headers sent with each request.

- **limit.context**: Maximum input tokens the model accepts.

- **limit.output**: Maximum tokens the model can generate.

The `limit` fields allow OpenCode to understand how much context you have left. Standard providers pull these from models.dev automatically.

---

## [Troubleshooting](#troubleshooting)

If you are having trouble with configuring a provider, check the following:

- **Check the auth setup**: Run `opencode auth list` to see if the credentials for the provider are added to your config. This doesn’t apply to providers like Amazon Bedrock, that rely on environment variables for their auth.

- For custom providers, check the opencode config and: Make sure the provider ID used in the `/connect` command matches the ID in your opencode config.

- The right npm package is used for the provider. For example, use `@ai-sdk/cerebras` for Cerebras. And for all other OpenAI-compatible providers, use `@ai-sdk/openai-compatible` (for `/v1/chat/completions`); if a model uses `/v1/responses`, use `@ai-sdk/openai`. For mixed setups under one provider, you can override per model via `provider.npm`.

- Check correct API endpoint is used in the `options.baseURL` field.


---
# File: rules.md
---
title: "Rules"
source: "https://opencode.ai/docs/rules/"
description: "Set custom instructions for opencode."
---

You can provide custom instructions to opencode by creating an `AGENTS.md` file. This is similar to Cursor’s rules. It contains instructions that will be included in the LLM’s context to customize its behavior for your specific project.

---

## [Initialize](#initialize)

To create a new `AGENTS.md` file, you can run the `/init` command in opencode.

> **Tip:** You should commit your project’s `AGENTS.md` file to Git.

`/init` scans the important files in your repo, may ask a couple of targeted questions when the codebase cannot answer them, and then creates or updates `AGENTS.md` with concise project-specific guidance.

It focuses on the things future agent sessions are most likely to need:

- build, lint, and test commands

- command order and focused verification steps when they matter

- architecture and repo structure that are not obvious from filenames alone

- project-specific conventions, setup quirks, and operational gotchas

- references to existing instruction sources like Cursor or Copilot rules

If you already have an `AGENTS.md`, `/init` will improve it in place instead of blindly replacing it.

---

## [Example](#example)

You can also just create this file manually. Here’s an example of some things you can put into an `AGENTS.md` file.

// AGENTS.md
```markdown
# SST v3 Monorepo Project

This is an SST v3 monorepo with TypeScript. The project uses bun workspaces for package management.

## Project Structure

- `packages/` - Contains all workspace packages (functions, core, web, etc.)
- `infra/` - Infrastructure definitions split by service (storage.ts, api.ts, web.ts)
- `sst.config.ts` - Main SST configuration with dynamic imports

## Code Standards

- Use TypeScript with strict mode enabled
- Shared code goes in `packages/core/` with proper exports configuration
- Functions go in `packages/functions/`
- Infrastructure should be split into logical files in `infra/`

## Monorepo Conventions

- Import shared modules using workspace names: `@my-app/core/example`
```

We are adding project-specific instructions here and this will be shared across your team.

---

## [Types](#types)

opencode also supports reading the `AGENTS.md` file from multiple locations. And this serves different purposes.

### [Project](#project)

Place an `AGENTS.md` in your project root for project-specific rules. These only apply when you are working in this directory or its sub-directories.

### [Global](#global)

You can also have global rules in a `~/.config/opencode/AGENTS.md` file. This gets applied across all opencode sessions.

Since this isn’t committed to Git or shared with your team, we recommend using this to specify any personal rules that the LLM should follow.

### [Claude Code Compatibility](#claude-code-compatibility)

For users migrating from Claude Code, OpenCode supports Claude Code’s file conventions as fallbacks:

- **Project rules**: `CLAUDE.md` in your project directory (used if no `AGENTS.md` exists)

- **Global rules**: `~/.claude/CLAUDE.md` (used if no `~/.config/opencode/AGENTS.md` exists)

- **Skills**: `~/.claude/skills/` — see [Agent Skills](/docs/skills/) for details

To disable Claude Code compatibility, set one of these environment variables:

```bash
export OPENCODE_DISABLE_CLAUDE_CODE=1        # Disable all .claude support
export OPENCODE_DISABLE_CLAUDE_CODE_PROMPT=1 # Disable only ~/.claude/CLAUDE.md
export OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1 # Disable only .claude/skills
```

---

## [Precedence](#precedence)

When opencode starts, it looks for rule files in this order:

- **Local files** by traversing up from the current directory (`AGENTS.md`, `CLAUDE.md`)

- **Global file** at `~/.config/opencode/AGENTS.md`

- **Claude Code file** at `~/.claude/CLAUDE.md` (unless disabled)

The first matching file wins in each category. For example, if you have both `AGENTS.md` and `CLAUDE.md`, only `AGENTS.md` is used. Similarly, `~/.config/opencode/AGENTS.md` takes precedence over `~/.claude/CLAUDE.md`.

---

## [Custom Instructions](#custom-instructions)

You can specify custom instruction files in your `opencode.json` or the global `~/.config/opencode/opencode.json`. This allows you and your team to reuse existing rules rather than having to duplicate them to AGENTS.md.

Example:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["CONTRIBUTING.md", "docs/guidelines.md", ".cursor/rules/*.md"]
}
```

You can also use remote URLs to load instructions from the web.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["https://raw.githubusercontent.com/my-org/shared-rules/main/style.md"]
}
```

Remote instructions are fetched with a 5 second timeout.

All instruction files are combined with your `AGENTS.md` files.

---

## [Referencing External Files](#referencing-external-files)

While opencode doesn’t automatically parse file references in `AGENTS.md`, you can achieve similar functionality in two ways:

### [Using opencode.json](#using-opencodejson)

The recommended approach is to use the `instructions` field in `opencode.json`:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["docs/development-standards.md", "test/testing-guidelines.md", "packages/*/AGENTS.md"]
}
```

### [Manual Instructions in AGENTS.md](#manual-instructions-in-agentsmd)

You can teach opencode to read external files by providing explicit instructions in your `AGENTS.md`. Here’s a practical example:

// AGENTS.md
```markdown
# TypeScript Project Rules

## External File Loading

CRITICAL: When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

Instructions:

- Do NOT preemptively load all references - use lazy loading based on actual need
- When loaded, treat content as mandatory instructions that override defaults
- Follow references recursively when needed

## Development Guidelines

For TypeScript code style and best practices: @docs/typescript-guidelines.md
For React component architecture and hooks patterns: @docs/react-patterns.md
For REST API design and error handling: @docs/api-standards.md
For testing strategies and coverage requirements: @test/testing-guidelines.md

## General Guidelines

Read the following file immediately as it's relevant to all workflows: @rules/general-guidelines.md.
```

This approach allows you to:

- Create modular, reusable rule files

- Share rules across projects via symlinks or git submodules

- Keep AGENTS.md concise while referencing detailed guidelines

- Ensure opencode loads files only when needed for the specific task

> **Tip:** For monorepos or projects with shared standards, using `opencode.json` with glob patterns (like `packages/*/AGENTS.md`) is more maintainable than manual instructions.


---
# File: sdk.md
---
title: "SDK"
source: "https://opencode.ai/docs/sdk/"
description: "Type-safe JS client for opencode server."
---

The opencode JS/TS SDK provides a type-safe client for interacting with the server. Use it to build integrations and control opencode programmatically.

[Learn more](/docs/server) about how the server works. For examples, check out the [projects](/docs/ecosystem#projects) built by the community.

---

## [Install](#install)

Install the SDK from npm:

```bash
npm install @opencode-ai/sdk
```

---

## [Create client](#create-client)

Create an instance of opencode:

```javascript
import { createOpencode } from "@opencode-ai/sdk"

const { client } = await createOpencode()
```

This starts both a server and a client

#### [Options](#options)

OptionTypeDescriptionDefaulthostnamestringServer hostname127.0.0.1portnumberServer port4096signalAbortSignalAbort signal for cancellationundefinedtimeoutnumberTimeout in ms for server start5000configConfigConfiguration object{}

---

## [Config](#config)

You can pass a configuration object to customize behavior. The instance still picks up your `opencode.json`, but you can override or add configuration inline:

```javascript
import { createOpencode } from "@opencode-ai/sdk"

const opencode = await createOpencode({
  hostname: "127.0.0.1",
  port: 4096,
  config: {
    model: "anthropic/claude-3-5-sonnet-20241022",
  },
})

console.log(`Server running at ${opencode.server.url}`)

opencode.server.close()
```

## [Client only](#client-only)

If you already have a running instance of opencode, you can create a client instance to connect to it:

```javascript
import { createOpencodeClient } from "@opencode-ai/sdk"

const client = createOpencodeClient({
  baseUrl: "http://localhost:4096",
})
```

#### [Options](#options-1)

OptionTypeDescriptionDefaultbaseUrlstringURL of the serverhttp://localhost:4096fetchfunctionCustom fetch implementationglobalThis.fetchparseAsstringResponse parsing methodautoresponseStylestringReturn style: data or fieldsfieldsthrowOnErrorbooleanThrow errors instead of returnfalse

---

## [Types](#types)

The SDK includes TypeScript definitions for all API types. Import them directly:

```typescript
import type { Session, Message, Part } from "@opencode-ai/sdk"
```

All types are generated from the server’s OpenAPI specification and available in the [types file](https://github.com/anomalyco/opencode/blob/dev/packages/sdk/js/src/gen/types.gen.ts).

---

## [Errors](#errors)

The SDK can throw errors that you can catch and handle:

```typescript
try {
  await client.session.get({ path: { id: "invalid-id" } })
} catch (error) {
  console.error("Failed to get session:", (error as Error).message)
}
```

---

## [Structured Output](#structured-output)

You can request structured JSON output from the model by specifying an `format` with a JSON schema. The model will use a `StructuredOutput` tool to return validated JSON matching your schema.

### [Basic Usage](#basic-usage)

```typescript
const result = await client.session.prompt({
  path: { id: sessionId },
  body: {
    parts: [{ type: "text", text: "Research Anthropic and provide company info" }],
    format: {
      type: "json_schema",
      schema: {
        type: "object",
        properties: {
          company: { type: "string", description: "Company name" },
          founded: { type: "number", description: "Year founded" },
          products: {
            type: "array",
            items: { type: "string" },
            description: "Main products",
          },
        },
        required: ["company", "founded"],
      },
    },
  },
})

// Access the structured output
console.log(result.data.info.structured_output)
// { company: "Anthropic", founded: 2021, products: ["Claude", "Claude API"] }
```

### [Output Format Types](#output-format-types)

TypeDescriptiontextDefault. Standard text response (no structured output)json_schemaReturns validated JSON matching the provided schema

### [JSON Schema Format](#json-schema-format)

When using `type: 'json_schema'`, provide:

FieldTypeDescriptiontype'json_schema'Required. Specifies JSON schema modeschemaobjectRequired. JSON Schema object defining the output structureretryCountnumberOptional. Number of validation retries (default: 2)

### [Error Handling](#error-handling)

If the model fails to produce valid structured output after all retries, the response will include a `StructuredOutputError`:

```typescript
if (result.data.info.error?.name === "StructuredOutputError") {
  console.error("Failed to produce structured output:", result.data.info.error.message)
  console.error("Attempts:", result.data.info.error.retries)
}
```

### [Best Practices](#best-practices)

- **Provide clear descriptions** in your schema properties to help the model understand what data to extract

- **Use `required`** to specify which fields must be present

- **Keep schemas focused** - complex nested schemas may be harder for the model to fill correctly

- **Set appropriate `retryCount`** - increase for complex schemas, decrease for simple ones

---

## [APIs](#apis)

The SDK exposes all server APIs through a type-safe client.

---

### [Global](#global)

MethodDescriptionResponseglobal.health()Check server health and version{ healthy: true, version: string }

---

#### [Examples](#examples)

```javascript
const health = await client.global.health()
console.log(health.data.version)
```

---

### [App](#app)

MethodDescriptionResponseapp.log()Write a log entrybooleanapp.agents()List all available agentsAgent[]

---

#### [Examples](#examples-1)

```javascript
// Write a log entry
await client.app.log({
  body: {
    service: "my-app",
    level: "info",
    message: "Operation completed",
  },
})

// List available agents
const agents = await client.app.agents()
```

---

### [Project](#project)

MethodDescriptionResponseproject.list()List all projectsProject[]project.current()Get current projectProject

---

#### [Examples](#examples-2)

```javascript
// List all projects
const projects = await client.project.list()

// Get current project
const currentProject = await client.project.current()
```

---

### [Path](#path)

MethodDescriptionResponsepath.get()Get current pathPath

---

#### [Examples](#examples-3)

```javascript
// Get current path information
const pathInfo = await client.path.get()
```

---

### [Config](#config-1)

MethodDescriptionResponseconfig.get()Get config infoConfigconfig.providers()List providers and default models{ providers: Provider[], default: { [key: string]: string } }

---

#### [Examples](#examples-4)

```javascript
const config = await client.config.get()

const { providers, default: defaults } = await client.config.providers()
```

---

### [Sessions](#sessions)

MethodDescriptionNotessession.list()List sessionsReturns Session[]session.get({ path })Get sessionReturns Sessionsession.children({ path })List child sessionsReturns Session[]session.create({ body })Create sessionReturns Sessionsession.delete({ path })Delete sessionReturns booleansession.update({ path, body })Update session propertiesReturns Sessionsession.init({ path, body })Analyze app and create AGENTS.mdReturns booleansession.abort({ path })Abort a running sessionReturns booleansession.share({ path })Share sessionReturns Sessionsession.unshare({ path })Unshare sessionReturns Sessionsession.summarize({ path, body })Summarize sessionReturns booleansession.messages({ path })List messages in a sessionReturns { info: Message, parts: Part[]}[]session.message({ path })Get message detailsReturns { info: Message, parts: Part[]}session.prompt({ path, body })Send prompt messagebody.noReply: true returns UserMessage (context only). Default returns AssistantMessage with AI response. Supports body.outputFormat for structured outputsession.command({ path, body })Send command to sessionReturns { info: AssistantMessage, parts: Part[]}session.shell({ path, body })Run a shell commandReturns AssistantMessagesession.revert({ path, body })Revert a messageReturns Sessionsession.unrevert({ path })Restore reverted messagesReturns SessionpostSessionByIdPermissionsByPermissionId({ path, body })Respond to a permission requestReturns boolean

---

#### [Examples](#examples-5)

```javascript
// Create and manage sessions
const session = await client.session.create({
  body: { title: "My session" },
})

const sessions = await client.session.list()

// Send a prompt message
const result = await client.session.prompt({
  path: { id: session.id },
  body: {
    model: { providerID: "anthropic", modelID: "claude-3-5-sonnet-20241022" },
    parts: [{ type: "text", text: "Hello!" }],
  },
})

// Inject context without triggering AI response (useful for plugins)
await client.session.prompt({
  path: { id: session.id },
  body: {
    noReply: true,
    parts: [{ type: "text", text: "You are a helpful assistant." }],
  },
})
```

---

### [Files](#files)

MethodDescriptionResponsefind.text({ query })Search for text in filesArray of match objects with path, lines, line_number, absolute_offset, submatchesfind.files({ query })Find files and directories by namestring[] (paths)find.symbols({ query })Find workspace symbolsSymbol[]file.read({ query })Read a file{ type: "raw" | "patch", content: string }file.status({ query? })Get status for tracked filesFile[]

`find.files` supports a few optional query fields:

- `type`: `"file"` or `"directory"`

- `directory`: override the project root for the search

- `limit`: max results (1–200)

---

#### [Examples](#examples-6)

```javascript
// Search and read files
const textResults = await client.find.text({
  query: { pattern: "function.*opencode" },
})

const files = await client.find.files({
  query: { query: "*.ts", type: "file" },
})

const directories = await client.find.files({
  query: { query: "packages", type: "directory", limit: 20 },
})

const content = await client.file.read({
  query: { path: "src/index.ts" },
})
```

---

### [TUI](#tui)

MethodDescriptionResponsetui.appendPrompt({ body })Append text to the promptbooleantui.openHelp()Open the help dialogbooleantui.openSessions()Open the session selectorbooleantui.openThemes()Open the theme selectorbooleantui.openModels()Open the model selectorbooleantui.submitPrompt()Submit the current promptbooleantui.clearPrompt()Clear the promptbooleantui.executeCommand({ body })Execute a commandbooleantui.showToast({ body })Show toast notificationboolean

---

#### [Examples](#examples-7)

```javascript
// Control TUI interface
await client.tui.appendPrompt({
  body: { text: "Add this to prompt" },
})

await client.tui.showToast({
  body: { message: "Task completed", variant: "success" },
})
```

---

### [Auth](#auth)

MethodDescriptionResponseauth.set({ ... })Set authentication credentialsboolean

---

#### [Examples](#examples-8)

```javascript
await client.auth.set({
  path: { id: "anthropic" },
  body: { type: "api", key: "your-api-key" },
})
```

---

### [Events](#events)

MethodDescriptionResponseevent.subscribe()Server-sent events streamServer-sent events stream

---

#### [Examples](#examples-9)

```javascript
// Listen to real-time events
const events = await client.event.subscribe()
for await (const event of events.stream) {
  console.log("Event:", event.type, event.properties)
}
```


---
# File: server.md
---
title: "Server"
source: "https://opencode.ai/docs/server/"
description: "Interact with opencode server over HTTP."
---

The `opencode serve` command runs a headless HTTP server that exposes an OpenAPI endpoint that an opencode client can use.

---

### [Usage](#usage)

```bash
opencode serve [--port ] [--hostname ] [--cors ]
```

#### [Options](#options)

FlagDescriptionDefault--portPort to listen on4096--hostnameHostname to listen on127.0.0.1--mdnsEnable mDNS discoveryfalse--mdns-domainCustom domain name for mDNS serviceopencode.local--corsAdditional browser origins to allow[]

`--cors` can be passed multiple times:

```bash
opencode serve --cors http://localhost:5173 --cors https://app.example.com
```

---

### [Authentication](#authentication)

Set `OPENCODE_SERVER_PASSWORD` to protect the server with HTTP basic auth. The username defaults to `opencode`, or set `OPENCODE_SERVER_USERNAME` to override it. This applies to both `opencode serve` and `opencode web`.

```bash
OPENCODE_SERVER_PASSWORD=your-password opencode serve
```

---

### [How it works](#how-it-works)

When you run `opencode` it starts a TUI and a server. Where the TUI is the client that talks to the server. The server exposes an OpenAPI 3.1 spec endpoint. This endpoint is also used to generate an [SDK](/docs/sdk).

> **Tip:** Use the opencode server to interact with opencode programmatically.

This architecture lets opencode support multiple clients and allows you to interact with opencode programmatically.

You can run `opencode serve` to start a standalone server. If you have the opencode TUI running, `opencode serve` will start a new server.

---

#### [Connect to an existing server](#connect-to-an-existing-server)

When you start the TUI it randomly assigns a port and hostname. You can instead pass in the `--hostname` and `--port` [flags](/docs/cli). Then use this to connect to its server.

The [`/tui`](#tui) endpoint can be used to drive the TUI through the server. For example, you can prefill or run a prompt. This setup is used by the OpenCode [IDE](/docs/ide) plugins.

---

## [Spec](#spec)

The server publishes an OpenAPI 3.1 spec that can be viewed at:

```plaintext
http://:/doc
```

For example, `http://localhost:4096/doc`. Use the spec to generate clients or inspect request and response types. Or view it in a Swagger explorer.

---

## [APIs](#apis)

The opencode server exposes the following APIs.

---

### [Global](#global)

MethodPathDescriptionResponseGET/global/healthGet server health and version{ healthy: true, version: string }GET/global/eventGet global events (SSE stream)Event stream

---

### [Project](#project)

MethodPathDescriptionResponseGET/projectList all projectsProject[]GET/project/currentGet the current projectProject

---

### [Path & VCS](#path--vcs)

MethodPathDescriptionResponseGET/pathGet the current pathPathGET/vcsGet VCS info for the current projectVcsInfo

---

### [Instance](#instance)

MethodPathDescriptionResponsePOST/instance/disposeDispose the current instanceboolean

---

### [Config](#config)

MethodPathDescriptionResponseGET/configGet config infoConfigPATCH/configUpdate configConfigGET/config/providersList providers and default models{ providers: Provider[], default: { [key: string]: string } }

---

### [Provider](#provider)

MethodPathDescriptionResponseGET/providerList all providers{ all: Provider[], default: {...}, connected: string[] }GET/provider/authGet provider authentication methods{ [providerID: string]: ProviderAuthMethod[] }POST/provider/{id}/oauth/authorizeAuthorize a provider using OAuthProviderAuthAuthorizationPOST/provider/{id}/oauth/callbackHandle OAuth callback for a providerboolean

---

### [Sessions](#sessions)

MethodPathDescriptionNotesGET/sessionList all sessionsReturns Session[]POST/sessionCreate a new sessionbody: { parentID?, title? }, returns SessionGET/session/statusGet session status for all sessionsReturns { [sessionID: string]: SessionStatus }GET/session/:idGet session detailsReturns SessionDELETE/session/:idDelete a session and all its dataReturns booleanPATCH/session/:idUpdate session propertiesbody: { title? }, returns SessionGET/session/:id/childrenGet a session’s child sessionsReturns Session[]GET/session/:id/todoGet the todo list for a sessionReturns Todo[]POST/session/:id/initAnalyze app and create AGENTS.mdbody: { messageID, providerID, modelID }, returns booleanPOST/session/:id/forkFork an existing session at a messagebody: { messageID? }, returns SessionPOST/session/:id/abortAbort a running sessionReturns booleanPOST/session/:id/shareShare a sessionReturns SessionDELETE/session/:id/shareUnshare a sessionReturns SessionGET/session/:id/diffGet the diff for this sessionquery: messageID?, returns FileDiff[]POST/session/:id/summarizeSummarize the sessionbody: { providerID, modelID }, returns booleanPOST/session/:id/revertRevert a messagebody: { messageID, partID? }, returns booleanPOST/session/:id/unrevertRestore all reverted messagesReturns booleanPOST/session/:id/permissions/:permissionIDRespond to a permission requestbody: { response, remember? }, returns boolean

---

### [Messages](#messages)

MethodPathDescriptionNotesGET/session/:id/messageList messages in a sessionquery: limit?, returns { info: Message, parts: Part[]}[]POST/session/:id/messageSend a message and wait for responsebody: { messageID?, model?, agent?, noReply?, system?, tools?, parts }, returns { info: Message, parts: Part[]}GET/session/:id/message/:messageIDGet message detailsReturns { info: Message, parts: Part[]}POST/session/:id/prompt_asyncSend a message asynchronously (no wait)body: same as /session/:id/message, returns 204 No ContentPOST/session/:id/commandExecute a slash commandbody: { messageID?, agent?, model?, command, arguments }, returns { info: Message, parts: Part[]}POST/session/:id/shellRun a shell commandbody: { agent, model?, command }, returns { info: Message, parts: Part[]}

---

### [Commands](#commands)

MethodPathDescriptionResponseGET/commandList all commandsCommand[]

---

### [Files](#files)

MethodPathDescriptionResponseGET/find?pattern=<pat>Search for text in filesArray of match objects with path, lines, line_number, absolute_offset, submatchesGET/find/file?query=<q>Find files and directories by namestring[] (paths)GET/find/symbol?query=<q>Find workspace symbolsSymbol[]GET/file?path=<path>List files and directoriesFileNode[]GET/file/content?path=<p>Read a fileFileContentGET/file/statusGet status for tracked filesFile[]

#### [`/find/file` query parameters](#findfile-query-parameters)

- `query` (required) — search string (fuzzy match)

- `type` (optional) — limit results to `"file"` or `"directory"`

- `directory` (optional) — override the project root for the search

- `limit` (optional) — max results (1–200)

- `dirs` (optional) — legacy flag (`"false"` returns only files)

---

### [Tools (Experimental)](#tools-experimental)

MethodPathDescriptionResponseGET/experimental/tool/idsList all tool IDsToolIDsGET/experimental/tool?provider=<p>&model=<m>List tools with JSON schemas for a modelToolList

---

### [LSP, Formatters & MCP](#lsp-formatters--mcp)

MethodPathDescriptionResponseGET/lspGet LSP server statusLSPStatus[]GET/formatterGet formatter statusFormatterStatus[]GET/mcpGet MCP server status{ [name: string]: MCPStatus }POST/mcpAdd MCP server dynamicallybody: { name, config }, returns MCP status object

---

### [Agents](#agents)

MethodPathDescriptionResponseGET/agentList all available agentsAgent[]

---

### [Logging](#logging)

MethodPathDescriptionResponsePOST/logWrite log entry. Body: { service, level, message, extra? }boolean

---

### [TUI](#tui)

MethodPathDescriptionResponsePOST/tui/append-promptAppend text to the promptbooleanPOST/tui/open-helpOpen the help dialogbooleanPOST/tui/open-sessionsOpen the session selectorbooleanPOST/tui/open-themesOpen the theme selectorbooleanPOST/tui/open-modelsOpen the model selectorbooleanPOST/tui/submit-promptSubmit the current promptbooleanPOST/tui/clear-promptClear the promptbooleanPOST/tui/execute-commandExecute a command ({ command })booleanPOST/tui/show-toastShow toast ({ title?, message, variant })booleanGET/tui/control/nextWait for the next control requestControl request objectPOST/tui/control/responseRespond to a control request ({ body })boolean

---

### [Auth](#auth)

MethodPathDescriptionResponsePUT/auth/:idSet authentication credentials. Body must match provider schemaboolean

---

### [Events](#events)

MethodPathDescriptionResponseGET/eventServer-sent events stream. First event is server.connected, then bus eventsServer-sent events stream

---

### [Docs](#docs)

MethodPathDescriptionResponseGET/docOpenAPI 3.1 specificationHTML page with OpenAPI spec


---
# File: share.md
---
title: "Share"
source: "https://opencode.ai/docs/share/"
description: "Share your OpenCode conversations."
---

OpenCode’s share feature allows you to create public links to your OpenCode conversations, so you can collaborate with teammates or get help from others.

> **Note:** Shared conversations are publicly accessible to anyone with the link.

---

## [How it works](#how-it-works)

When you share a conversation, OpenCode:

- Creates a unique public URL for your session

- Syncs your conversation history to our servers

- Makes the conversation accessible via the shareable link — `opncd.ai/s/`

---

## [Sharing](#sharing)

OpenCode supports three sharing modes that control how conversations are shared:

---

### [Manual (default)](#manual-default)

By default, OpenCode uses manual sharing mode. Sessions are not shared automatically, but you can manually share them using the `/share` command:

```plaintext
/share
```

This will generate a unique URL that’ll be copied to your clipboard.

To explicitly set manual mode in your [config file](/docs/config):

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "share": "manual"
}
```

---

### [Auto-share](#auto-share)

You can enable automatic sharing for all new conversations by setting the `share` option to `"auto"` in your [config file](/docs/config):

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "share": "auto"
}
```

With auto-share enabled, every new conversation will automatically be shared and a link will be generated.

---

### [Disabled](#disabled)

You can disable sharing entirely by setting the `share` option to `"disabled"` in your [config file](/docs/config):

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "share": "disabled"
}
```

To enforce this across your team for a given project, add it to the `opencode.json` in your project and check into Git.

---

## [Un-sharing](#un-sharing)

To stop sharing a conversation and remove it from public access:

```plaintext
/unshare
```

This will remove the share link and delete the data related to the conversation.

---

## [Privacy](#privacy)

There are a few things to keep in mind when sharing a conversation.

---

### [Data retention](#data-retention)

Shared conversations remain accessible until you explicitly unshare them. This includes:

- Full conversation history

- All messages and responses

- Session metadata

---

### [Recommendations](#recommendations)

- Only share conversations that don’t contain sensitive information.

- Review conversation content before sharing.

- Unshare conversations when collaboration is complete.

- Avoid sharing conversations with proprietary code or confidential data.

- For sensitive projects, disable sharing entirely.

---

## [For enterprises](#for-enterprises)

For enterprise deployments, the share feature can be:

- **Disabled** entirely for security compliance

- **Restricted** to users authenticated through SSO only

- **Self-hosted** on your own infrastructure

[Learn more](/docs/enterprise) about using opencode in your organization.


---
# File: sitemap-index.xml.md
---
title: "Untitled"
---

https://opencode.ai/docs/sitemap-0.xml


---
# File: skills.md
---
title: "Agent Skills"
source: "https://opencode.ai/docs/skills/"
description: "Define reusable behavior via SKILL.md definitions"
---

Agent skills let OpenCode discover reusable instructions from your repo or home directory. Skills are loaded on-demand via the native `skill` tool—agents see available skills and can load the full content when needed.

---

## [Place files](#place-files)

Create one folder per skill name and put a `SKILL.md` inside it. OpenCode searches these locations:

- Project config: `.opencode/skills//SKILL.md`

- Global config: `~/.config/opencode/skills//SKILL.md`

- Project Claude-compatible: `.claude/skills//SKILL.md`

- Global Claude-compatible: `~/.claude/skills//SKILL.md`

- Project agent-compatible: `.agents/skills//SKILL.md`

- Global agent-compatible: `~/.agents/skills//SKILL.md`

---

## [Understand discovery](#understand-discovery)

For project-local paths, OpenCode walks up from your current working directory until it reaches the git worktree. It loads any matching `skills/*/SKILL.md` in `.opencode/` and any matching `.claude/skills/*/SKILL.md` or `.agents/skills/*/SKILL.md` along the way.

Global definitions are also loaded from `~/.config/opencode/skills/*/SKILL.md`, `~/.claude/skills/*/SKILL.md`, and `~/.agents/skills/*/SKILL.md`.

---

## [Write frontmatter](#write-frontmatter)

Each `SKILL.md` must start with YAML frontmatter. Only these fields are recognized:

- `name` (required)

- `description` (required)

- `license` (optional)

- `compatibility` (optional)

- `metadata` (optional, string-to-string map)

Unknown frontmatter fields are ignored.

---

## [Validate names](#validate-names)

`name` must:

- Be 1–64 characters

- Be lowercase alphanumeric with single hyphen separators

- Not start or end with `-`

- Not contain consecutive `--`

- Match the directory name that contains `SKILL.md`

Equivalent regex:

```text
^[a-z0-9]+(-[a-z0-9]+)*$
```

---

## [Follow length rules](#follow-length-rules)

`description` must be 1-1024 characters. Keep it specific enough for the agent to choose correctly.

---

## [Use an example](#use-an-example)

Create `.opencode/skills/git-release/SKILL.md` like this:

```markdown
---
name: git-release
description: Create consistent releases and changelogs
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do

- Draft release notes from merged PRs
- Propose a version bump
- Provide a copy-pasteable `gh release create` command

## When to use me

Use this when you are preparing a tagged release.
Ask clarifying questions if the target versioning scheme is unclear.
```

---

## [Recognize tool description](#recognize-tool-description)

OpenCode lists available skills in the `skill` tool description. Each entry includes the skill name and description:

```xml

    git-release
    Create consistent releases and changelogs

```

The agent loads a skill by calling the tool:

```plaintext
skill({ name: "git-release" })
```

---

## [Configure permissions](#configure-permissions)

Control which skills agents can access using pattern-based permissions in `opencode.json`:

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "pr-review": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

PermissionBehaviorallowSkill loads immediatelydenySkill hidden from agent, access rejectedaskUser prompted for approval before loading

Patterns support wildcards: `internal-*` matches `internal-docs`, `internal-tools`, etc.

---

## [Override per agent](#override-per-agent)

Give specific agents different permissions than the global defaults.

**For custom agents** (in agent frontmatter):

```yaml
---
permission:
  skill:
    "documents-*": "allow"
---
```

**For built-in agents** (in `opencode.json`):

```json
{
  "agent": {
    "plan": {
      "permission": {
        "skill": {
          "internal-*": "allow"
        }
      }
    }
  }
}
```

---

## [Disable the skill tool](#disable-the-skill-tool)

Completely disable skills for agents that shouldn’t use them:

**For custom agents**:

```yaml
---
tools:
  skill: false
---
```

**For built-in agents**:

```json
{
  "agent": {
    "plan": {
      "tools": {
        "skill": false
      }
    }
  }
}
```

When disabled, the `` section is omitted entirely.

---

## [Troubleshoot loading](#troubleshoot-loading)

If a skill does not show up:

- Verify `SKILL.md` is spelled in all caps

- Check that frontmatter includes `name` and `description`

- Ensure skill names are unique across all locations

- Check permissions—skills with `deny` are hidden from agents


---
# File: themes.md
---
title: "Themes"
source: "https://opencode.ai/docs/themes/"
description: "Select a built-in theme or define your own."
---

With OpenCode you can select from one of several built-in themes, use a theme that adapts to your terminal theme, or define your own custom theme.

By default, OpenCode uses our own `opencode` theme.

---

## [Terminal requirements](#terminal-requirements)

For themes to display correctly with their full color palette, your terminal must support **truecolor** (24-bit color). Most modern terminals support this by default, but you may need to enable it:

- **Check support**: Run `echo $COLORTERM` - it should output `truecolor` or `24bit`

- **Enable truecolor**: Set the environment variable `COLORTERM=truecolor` in your shell profile

- **Terminal compatibility**: Ensure your terminal emulator supports 24-bit color (most modern terminals like iTerm2, Alacritty, Kitty, Windows Terminal, and recent versions of GNOME Terminal do)

Without truecolor support, themes may appear with reduced color accuracy or fall back to the nearest 256-color approximation.

---

## [Built-in themes](#built-in-themes)

OpenCode comes with several built-in themes.

NameDescriptionsystemAdapts to your terminal’s background colortokyonightBased on the Tokyonight themeeverforestBased on the Everforest themeayuBased on the Ayu dark themecatppuccinBased on the Catppuccin themecatppuccin-macchiatoBased on the Catppuccin themegruvboxBased on the Gruvbox themekanagawaBased on the Kanagawa themenordBased on the Nord themematrixHacker-style green on black themeone-darkBased on the Atom One Dark theme

And more, we are constantly adding new themes.

---

## [System theme](#system-theme)

The `system` theme is designed to automatically adapt to your terminal’s color scheme. Unlike traditional themes that use fixed colors, the *system* theme:

- **Generates gray scale**: Creates a custom gray scale based on your terminal’s background color, ensuring optimal contrast.

- **Uses ANSI colors**: Leverages standard ANSI colors (0-15) for syntax highlighting and UI elements, which respect your terminal’s color palette.

- **Preserves terminal defaults**: Uses `none` for text and background colors to maintain your terminal’s native appearance.

The system theme is for users who:

- Want OpenCode to match their terminal’s appearance

- Use custom terminal color schemes

- Prefer a consistent look across all terminal applications

---

## [Using a theme](#using-a-theme)

You can select a theme by bringing up the theme select with the `/theme` command. Or you can specify it in `tui.json`.

// tui.json
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "theme": "tokyonight"
}
```

---

## [Custom themes](#custom-themes)

OpenCode supports a flexible JSON-based theme system that allows users to create and customize themes easily.

---

### [Hierarchy](#hierarchy)

Themes are loaded from multiple directories in the following order where later directories override earlier ones:

- **Built-in themes** - These are embedded in the binary

- **User config directory** - Defined in `~/.config/opencode/themes/*.json` or `$XDG_CONFIG_HOME/opencode/themes/*.json`

- **Project root directory** - Defined in the `/.opencode/themes/*.json`

- **Current working directory** - Defined in `./.opencode/themes/*.json`

If multiple directories contain a theme with the same name, the theme from the directory with higher priority will be used.

---

### [Creating a theme](#creating-a-theme)

To create a custom theme, create a JSON file in one of the theme directories.

For user-wide themes:

```bash
mkdir -p ~/.config/opencode/themes
vim ~/.config/opencode/themes/my-theme.json
```

And for project-specific themes.

```bash
mkdir -p .opencode/themes
vim .opencode/themes/my-theme.json
```

---

### [JSON format](#json-format)

Themes use a flexible JSON format with support for:

- **Hex colors**: `"#ffffff"`

- **ANSI colors**: `3` (0-255)

- **Color references**: `"primary"` or custom definitions

- **Dark/light variants**: `{"dark": "#000", "light": "#fff"}`

- **No color**: `"none"` - Uses the terminal’s default color or transparent

---

### [Color definitions](#color-definitions)

The `defs` section is optional and it allows you to define reusable colors that can be referenced in the theme.

---

### [Terminal defaults](#terminal-defaults)

The special value `"none"` can be used for any color to inherit the terminal’s default color. This is particularly useful for creating themes that blend seamlessly with your terminal’s color scheme:

- `"text": "none"` - Uses terminal’s default foreground color

- `"background": "none"` - Uses terminal’s default background color

---

### [Example](#example)

Here’s an example of a custom theme:

// my-theme.json
```json
{
  "$schema": "https://opencode.ai/theme.json",
  "defs": {
    "nord0": "#2E3440",
    "nord1": "#3B4252",
    "nord2": "#434C5E",
    "nord3": "#4C566A",
    "nord4": "#D8DEE9",
    "nord5": "#E5E9F0",
    "nord6": "#ECEFF4",
    "nord7": "#8FBCBB",
    "nord8": "#88C0D0",
    "nord9": "#81A1C1",
    "nord10": "#5E81AC",
    "nord11": "#BF616A",
    "nord12": "#D08770",
    "nord13": "#EBCB8B",
    "nord14": "#A3BE8C",
    "nord15": "#B48EAD"
  },
  "theme": {
    "primary": {
      "dark": "nord8",
      "light": "nord10"
    },
    "secondary": {
      "dark": "nord9",
      "light": "nord9"
    },
    "accent": {
      "dark": "nord7",
      "light": "nord7"
    },
    "error": {
      "dark": "nord11",
      "light": "nord11"
    },
    "warning": {
      "dark": "nord12",
      "light": "nord12"
    },
    "success": {
      "dark": "nord14",
      "light": "nord14"
    },
    "info": {
      "dark": "nord8",
      "light": "nord10"
    },
    "text": {
      "dark": "nord4",
      "light": "nord0"
    },
    "textMuted": {
      "dark": "nord3",
      "light": "nord1"
    },
    "background": {
      "dark": "nord0",
      "light": "nord6"
    },
    "backgroundPanel": {
      "dark": "nord1",
      "light": "nord5"
    },
    "backgroundElement": {
      "dark": "nord1",
      "light": "nord4"
    },
    "border": {
      "dark": "nord2",
      "light": "nord3"
    },
    "borderActive": {
      "dark": "nord3",
      "light": "nord2"
    },
    "borderSubtle": {
      "dark": "nord2",
      "light": "nord3"
    },
    "diffAdded": {
      "dark": "nord14",
      "light": "nord14"
    },
    "diffRemoved": {
      "dark": "nord11",
      "light": "nord11"
    },
    "diffContext": {
      "dark": "nord3",
      "light": "nord3"
    },
    "diffHunkHeader": {
      "dark": "nord3",
      "light": "nord3"
    },
    "diffHighlightAdded": {
      "dark": "nord14",
      "light": "nord14"
    },
    "diffHighlightRemoved": {
      "dark": "nord11",
      "light": "nord11"
    },
    "diffAddedBg": {
      "dark": "#3B4252",
      "light": "#E5E9F0"
    },
    "diffRemovedBg": {
      "dark": "#3B4252",
      "light": "#E5E9F0"
    },
    "diffContextBg": {
      "dark": "nord1",
      "light": "nord5"
    },
    "diffLineNumber": {
      "dark": "nord2",
      "light": "nord4"
    },
    "diffAddedLineNumberBg": {
      "dark": "#3B4252",
      "light": "#E5E9F0"
    },
    "diffRemovedLineNumberBg": {
      "dark": "#3B4252",
      "light": "#E5E9F0"
    },
    "markdownText": {
      "dark": "nord4",
      "light": "nord0"
    },
    "markdownHeading": {
      "dark": "nord8",
      "light": "nord10"
    },
    "markdownLink": {
      "dark": "nord9",
      "light": "nord9"
    },
    "markdownLinkText": {
      "dark": "nord7",
      "light": "nord7"
    },
    "markdownCode": {
      "dark": "nord14",
      "light": "nord14"
    },
    "markdownBlockQuote": {
      "dark": "nord3",
      "light": "nord3"
    },
    "markdownEmph": {
      "dark": "nord12",
      "light": "nord12"
    },
    "markdownStrong": {
      "dark": "nord13",
      "light": "nord13"
    },
    "markdownHorizontalRule": {
      "dark": "nord3",
      "light": "nord3"
    },
    "markdownListItem": {
      "dark": "nord8",
      "light": "nord10"
    },
    "markdownListEnumeration": {
      "dark": "nord7",
      "light": "nord7"
    },
    "markdownImage": {
      "dark": "nord9",
      "light": "nord9"
    },
    "markdownImageText": {
      "dark": "nord7",
      "light": "nord7"
    },
    "markdownCodeBlock": {
      "dark": "nord4",
      "light": "nord0"
    },
    "syntaxComment": {
      "dark": "nord3",
      "light": "nord3"
    },
    "syntaxKeyword": {
      "dark": "nord9",
      "light": "nord9"
    },
    "syntaxFunction": {
      "dark": "nord8",
      "light": "nord8"
    },
    "syntaxVariable": {
      "dark": "nord7",
      "light": "nord7"
    },
    "syntaxString": {
      "dark": "nord14",
      "light": "nord14"
    },
    "syntaxNumber": {
      "dark": "nord15",
      "light": "nord15"
    },
    "syntaxType": {
      "dark": "nord7",
      "light": "nord7"
    },
    "syntaxOperator": {
      "dark": "nord9",
      "light": "nord9"
    },
    "syntaxPunctuation": {
      "dark": "nord4",
      "light": "nord0"
    }
  }
}
```


---
# File: tools.md
---
title: "Tools"
source: "https://opencode.ai/docs/tools/"
description: "Manage the tools an LLM can use."
---

Tools allow the LLM to perform actions in your codebase. OpenCode comes with a set of built-in tools, but you can extend it with [custom tools](/docs/custom-tools) or [MCP servers](/docs/mcp-servers).

By default, all tools are **enabled** and don’t need permission to run. You can control tool behavior through [permissions](/docs/permissions).

---

## [Configure](#configure)

Use the `permission` field to control tool behavior. You can allow, deny, or require approval for each tool.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "deny",
    "bash": "ask",
    "webfetch": "allow"
  }
}
```

You can also use wildcards to control multiple tools at once. For example, to require approval for all tools from an MCP server:

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "mymcp_*": "ask"
  }
}
```

[Learn more](/docs/permissions) about configuring permissions.

---

## [Built-in](#built-in)

Here are all the built-in tools available in OpenCode.

---

### [bash](#bash)

Execute shell commands in your project environment.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": "allow"
  }
}
```

This tool allows the LLM to run terminal commands like `npm install`, `git status`, or any other shell command.

---

### [edit](#edit)

Modify existing files using exact string replacements.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "allow"
  }
}
```

This tool performs precise edits to files by replacing exact text matches. It’s the primary way the LLM modifies code.

---

### [write](#write)

Create new files or overwrite existing ones.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "allow"
  }
}
```

Use this to allow the LLM to create new files. It will overwrite existing files if they already exist.

> **Note:** The `write` tool is controlled by the `edit` permission, which covers all file modifications (`edit`, `write`, `apply_patch`, `multiedit`).

---

### [read](#read)

Read file contents from your codebase.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": "allow"
  }
}
```

This tool reads files and returns their contents. It supports reading specific line ranges for large files.

---

### [grep](#grep)

Search file contents using regular expressions.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "grep": "allow"
  }
}
```

Fast content search across your codebase. Supports full regex syntax and file pattern filtering.

---

### [glob](#glob)

Find files by pattern matching.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "glob": "allow"
  }
}
```

Search for files using glob patterns like `**/*.js` or `src/**/*.ts`. Returns matching file paths sorted by modification time.

---

### [list](#list)

List files and directories in a given path.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "list": "allow"
  }
}
```

This tool lists directory contents. It accepts glob patterns to filter results.

---

### [lsp (experimental)](#lsp-experimental)

Interact with your configured LSP servers to get code intelligence features like definitions, references, hover info, and call hierarchy.

> **Note:** This tool is only available when `OPENCODE_EXPERIMENTAL_LSP_TOOL=true` (or `OPENCODE_EXPERIMENTAL=true`).

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "lsp": "allow"
  }
}
```

Supported operations include `goToDefinition`, `findReferences`, `hover`, `documentSymbol`, `workspaceSymbol`, `goToImplementation`, `prepareCallHierarchy`, `incomingCalls`, and `outgoingCalls`.

To configure which LSP servers are available for your project, see [LSP Servers](/docs/lsp).

---

### [apply_patch](#apply_patch)

Apply patches to files.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "allow"
  }
}
```

This tool applies patch files to your codebase. Useful for applying diffs and patches from various sources.

When handling `tool.execute.before` or `tool.execute.after` hooks, check `input.tool === "apply_patch"` (not `"patch"`).

`apply_patch` uses `output.args.patchText` instead of `output.args.filePath`. Paths are embedded in marker lines within `patchText` and are relative to the project root (for example: `*** Add File: src/new-file.ts`, `*** Update File: src/existing.ts`, `*** Move to: src/renamed.ts`, `*** Delete File: src/obsolete.ts`).

> **Note:** The `apply_patch` tool is controlled by the `edit` permission, which covers all file modifications (`edit`, `write`, `apply_patch`, `multiedit`).

---

### [skill](#skill)

Load a [skill](/docs/skills) (a `SKILL.md` file) and return its content in the conversation.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "skill": "allow"
  }
}
```

---

### [todowrite](#todowrite)

Manage todo lists during coding sessions.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "todowrite": "allow"
  }
}
```

Creates and updates task lists to track progress during complex operations. The LLM uses this to organize multi-step tasks.

> **Note:** This tool is disabled for subagents by default, but you can enable it manually. [Learn more](/docs/agents/#permissions)

---

### [webfetch](#webfetch)

Fetch web content.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "webfetch": "allow"
  }
}
```

Allows the LLM to fetch and read web pages. Useful for looking up documentation or researching online resources.

---

### [websearch](#websearch)

Search the web for information.

> **Note:** This tool is only available when using the OpenCode provider or when the `OPENCODE_ENABLE_EXA` environment variable is set to any truthy value (e.g., `true` or `1`).

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "websearch": "allow"
  }
}
```

Performs web searches using Exa AI to find relevant information online. Useful for researching topics, finding current events, or gathering information beyond the training data cutoff.

No API key is required — the tool connects directly to Exa AI’s hosted MCP service without authentication.

> **Tip:** Use `websearch` when you need to find information (discovery), and `webfetch` when you need to retrieve content from a specific URL (retrieval).

---

### [question](#question)

Ask the user questions during execution.

// opencode.json
```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "question": "allow"
  }
}
```

This tool allows the LLM to ask the user questions during a task. It’s useful for:

- Gathering user preferences or requirements

- Clarifying ambiguous instructions

- Getting decisions on implementation choices

- Offering choices about what direction to take

Each question includes a header, the question text, and a list of options. Users can select from the provided options or type a custom answer. When there are multiple questions, users can navigate between them before submitting all answers.

---

## [Custom tools](#custom-tools)

Custom tools let you define your own functions that the LLM can call. These are defined in your config file and can execute arbitrary code.

[Learn more](/docs/custom-tools) about creating custom tools.

---

## [MCP servers](#mcp-servers)

MCP (Model Context Protocol) servers allow you to integrate external tools and services. This includes database access, API integrations, and third-party services.

[Learn more](/docs/mcp-servers) about configuring MCP servers.

---

## [Internals](#internals)

Internally, tools like `grep`, `glob`, and `list` use [ripgrep](https://github.com/BurntSushi/ripgrep) under the hood. By default, ripgrep respects `.gitignore` patterns, which means files and directories listed in your `.gitignore` will be excluded from searches and listings.

---

### [Ignore patterns](#ignore-patterns)

To include files that would normally be ignored, create a `.ignore` file in your project root. This file can explicitly allow certain paths.

// .ignore
```text
!node_modules/
!dist/
!build/
```

For example, this `.ignore` file allows ripgrep to search within `node_modules/`, `dist/`, and `build/` directories even if they’re listed in `.gitignore`.


---
# File: troubleshooting.md
---
title: "Troubleshooting"
source: "https://opencode.ai/docs/troubleshooting/"
description: "Common issues and how to resolve them."
---

To debug issues with OpenCode, start by checking the logs and local data it stores on disk.

---

## [Logs](#logs)

Log files are written to:

- **macOS/Linux**: `~/.local/share/opencode/log/`

- **Windows**: Press `WIN+R` and paste `%USERPROFILE%\.local\share\opencode\log`

Log files are named with timestamps (e.g., `2025-01-09T123456.log`) and the most recent 10 log files are kept.

You can set the log level with the `--log-level` command-line option to get more detailed debug information. For example, `opencode --log-level DEBUG`.

---

## [Storage](#storage)

opencode stores session data and other application data on disk at:

- **macOS/Linux**: `~/.local/share/opencode/`

- **Windows**: Press `WIN+R` and paste `%USERPROFILE%\.local\share\opencode`

This directory contains:

- `auth.json` - Authentication data like API keys, OAuth tokens

- `log/` - Application logs

- `project/` - Project-specific data like session and message data If the project is within a Git repo, it is stored in `.//storage/`

- If it is not a Git repo, it is stored in `./global/storage/`

---

## [Desktop app](#desktop-app)

OpenCode Desktop runs a local OpenCode server (the `opencode-cli` sidecar) in the background. Most issues are caused by a misbehaving plugin, a corrupted cache, or a bad server setting.

### [Quick checks](#quick-checks)

- Fully quit and relaunch the app.

- If the app shows an error screen, click **Restart** and copy the error details.

- macOS only: `OpenCode` menu -> **Reload Webview** (helps if the UI is blank/frozen).

---

### [Disable plugins](#disable-plugins)

If the desktop app is crashing on launch, hanging, or behaving strangely, start by disabling plugins.

#### [Check the global config](#check-the-global-config)

Open your global config file and look for a `plugin` key.

- **macOS/Linux**: `~/.config/opencode/opencode.jsonc` (or `~/.config/opencode/opencode.json`)

- **macOS/Linux** (older installs): `~/.local/share/opencode/opencode.jsonc`

- **Windows**: Press `WIN+R` and paste `%USERPROFILE%\.config\opencode\opencode.jsonc`

If you have plugins configured, temporarily disable them by removing the key or setting it to an empty array:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [],
}
```

#### [Check plugin directories](#check-plugin-directories)

OpenCode can also load local plugins from disk. Temporarily move these out of the way (or rename the folder) and restart the desktop app:

- **Global plugins** **macOS/Linux**: `~/.config/opencode/plugins/`

- **Windows**: Press `WIN+R` and paste `%USERPROFILE%\.config\opencode\plugins`

- **Project plugins** (only if you use per-project config) `/.opencode/plugins/`

If the app starts working again, re-enable plugins one at a time to find which one is causing the issue.

---

### [Clear the cache](#clear-the-cache)

If disabling plugins doesn’t help (or a plugin install is stuck), clear the cache so OpenCode can rebuild it.

- Quit OpenCode Desktop completely.

- Delete the cache directory:

- **macOS**: Finder -> `Cmd+Shift+G` -> paste `~/.cache/opencode`

- **Linux**: delete `~/.cache/opencode` (or run `rm -rf ~/.cache/opencode`)

- **Windows**: Press `WIN+R` and paste `%USERPROFILE%\.cache\opencode`

- Restart OpenCode Desktop.

---

### [Fix server connection issues](#fix-server-connection-issues)

OpenCode Desktop can either start its own local server (default) or connect to a server URL you configured.

If you see a **“Connection Failed”** dialog (or the app never gets past the splash screen), check for a custom server URL.

#### [Clear the desktop default server URL](#clear-the-desktop-default-server-url)

From the Home screen, click the server name (with the status dot) to open the Server picker. In the **Default server** section, click **Clear**.

#### [Remove `server.port` / `server.hostname` from your config](#remove-serverport--serverhostname-from-your-config)

If your `opencode.json(c)` contains a `server` section, temporarily remove it and restart the desktop app.

#### [Check environment variables](#check-environment-variables)

If you have `OPENCODE_PORT` set in your environment, the desktop app will try to use that port for the local server.

- Unset `OPENCODE_PORT` (or pick a free port) and restart.

---

### [Linux: Wayland / X11 issues](#linux-wayland--x11-issues)

On Linux, some Wayland setups can cause blank windows or compositor errors.

- If you’re on Wayland and the app is blank/crashing, try launching with `OC_ALLOW_WAYLAND=1`.

- If that makes things worse, remove it and try launching under an X11 session instead.

---

### [Windows: WebView2 runtime](#windows-webview2-runtime)

On Windows, OpenCode Desktop requires the Microsoft Edge **WebView2 Runtime**. If the app opens to a blank window or won’t start, install/update WebView2 and try again.

---

### [Windows: General performance issues](#windows-general-performance-issues)

If you’re experiencing slow performance, file access issues, or terminal problems on Windows, try using [WSL (Windows Subsystem for Linux)](/docs/windows-wsl). WSL provides a Linux environment that works more seamlessly with OpenCode’s features.

---

### [Notifications not showing](#notifications-not-showing)

OpenCode Desktop only shows system notifications when:

- notifications are enabled for OpenCode in your OS settings, and

- the app window is not focused.

---

### [Reset desktop app storage (last resort)](#reset-desktop-app-storage-last-resort)

If the app won’t start and you can’t clear settings from inside the UI, reset the desktop app’s saved state.

- Quit OpenCode Desktop.

- Find and delete these files (they live in the OpenCode Desktop app data directory):

- `opencode.settings.dat` (desktop default server URL)

- `opencode.global.dat` and `opencode.workspace.*.dat` (UI state like recent servers/projects)

To find the directory quickly:

- **macOS**: Finder -> `Cmd+Shift+G` -> `~/Library/Application Support` (then search for the filenames above)

- **Linux**: search under `~/.local/share` for the filenames above

- **Windows**: Press `WIN+R` -> `%APPDATA%` (then search for the filenames above)

---

## [Getting help](#getting-help)

If you’re experiencing issues with OpenCode:

- **Report issues on GitHub** The best way to report bugs or request features is through our GitHub repository: [**github.com/anomalyco/opencode/issues**](https://github.com/anomalyco/opencode/issues) Before creating a new issue, search existing issues to see if your problem has already been reported.

- **Join our Discord** For real-time help and community discussion, join our Discord server: [**opencode.ai/discord**](https://opencode.ai/discord)

---

## [Common issues](#common-issues)

Here are some common issues and how to resolve them.

---

### [OpenCode won’t start](#opencode-wont-start)

- Check the logs for error messages

- Try running with `--print-logs` to see output in the terminal

- Ensure you have the latest version with `opencode upgrade`

---

### [Authentication issues](#authentication-issues)

- Try re-authenticating with the `/connect` command in the TUI

- Check that your API keys are valid

- Ensure your network allows connections to the provider’s API

---

### [Model not available](#model-not-available)

- Check that you’ve authenticated with the provider

- Verify the model name in your config is correct

- Some models may require specific access or subscriptions

If you encounter `ProviderModelNotFoundError` you are most likely incorrectly referencing a model somewhere. Models should be referenced like so: `/`

Examples:

- `openai/gpt-4.1`

- `openrouter/google/gemini-2.5-flash`

- `opencode/kimi-k2`

To figure out what models you have access to, run `opencode models`

---

### [ProviderInitError](#provideriniterror)

If you encounter a ProviderInitError, you likely have an invalid or corrupted configuration.

To resolve this:

- First, verify your provider is set up correctly by following the [providers guide](/docs/providers)

- If the issue persists, try clearing your stored configuration: ```bash rm -rf ~/.local/share/opencode ``` On Windows, press `WIN+R` and delete: `%USERPROFILE%\.local\share\opencode`

- Re-authenticate with your provider using the `/connect` command in the TUI.

---

### [AI_APICallError and provider package issues](#ai_apicallerror-and-provider-package-issues)

If you encounter API call errors, this may be due to outdated provider packages. opencode dynamically installs provider packages (OpenAI, Anthropic, Google, etc.) as needed and caches them locally.

To resolve provider package issues:

- Clear the provider package cache: ```bash rm -rf ~/.cache/opencode ``` On Windows, press `WIN+R` and delete: `%USERPROFILE%\.cache\opencode`

- Restart opencode to reinstall the latest provider packages

This will force opencode to download the most recent versions of provider packages, which often resolves compatibility issues with model parameters and API changes.

---

### [Copy/paste not working on Linux](#copypaste-not-working-on-linux)

Linux users need to have one of the following clipboard utilities installed for copy/paste functionality to work:

**For X11 systems:**

```bash
apt install -y xclip
# or
apt install -y xsel
```

**For Wayland systems:**

```bash
apt install -y wl-clipboard
```

**For headless environments:**

```bash
apt install -y xvfb
# and run:
Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
export DISPLAY=:99.0
```

opencode will detect if you’re using Wayland and prefer `wl-clipboard`, otherwise it will try to find clipboard tools in order of: `xclip` and `xsel`.


---
# File: tui.md
---
title: "TUI"
source: "https://opencode.ai/docs/tui/"
description: "Using the OpenCode terminal user interface."
---

OpenCode provides an interactive terminal interface or TUI for working on your projects with an LLM.

Running OpenCode starts the TUI for the current directory.

```bash
opencode
```

Or you can start it for a specific working directory.

```bash
opencode /path/to/project
```

Once you’re in the TUI, you can prompt it with a message.

```text
Give me a quick summary of the codebase.
```

---

## [File references](#file-references)

You can reference files in your messages using `@`. This does a fuzzy file search in the current working directory.

> **Tip:** You can also use `@` to reference files in your messages.

```text
How is auth handled in @packages/functions/src/api/index.ts?
```

The content of the file is added to the conversation automatically.

---

## [Bash commands](#bash-commands)

Start a message with `!` to run a shell command.

```bash
!ls -la
```

The output of the command is added to the conversation as a tool result.

---

## [Commands](#commands)

When using the OpenCode TUI, you can type `/` followed by a command name to quickly execute actions. For example:

```bash
/help
```

Most commands also have keybind using `ctrl+x` as the leader key, where `ctrl+x` is the default leader key. [Learn more](/docs/keybinds).

Here are all available slash commands:

---

### [connect](#connect)

Add a provider to OpenCode. Allows you to select from available providers and add their API keys.

```bash
/connect
```

---

### [compact](#compact)

Compact the current session. *Alias*: `/summarize`

```bash
/compact
```

**Keybind:** `ctrl+x c`

---

### [details](#details)

Toggle tool execution details.

```bash
/details
```

**Keybind:** `ctrl+x d`

---

### [editor](#editor)

Open external editor for composing messages. Uses the editor set in your `EDITOR` environment variable. [Learn more](#editor-setup).

```bash
/editor
```

**Keybind:** `ctrl+x e`

---

### [exit](#exit)

Exit OpenCode. *Aliases*: `/quit`, `/q`

```bash
/exit
```

**Keybind:** `ctrl+x q`

---

### [export](#export)

Export current conversation to Markdown and open in your default editor. Uses the editor set in your `EDITOR` environment variable. [Learn more](#editor-setup).

```bash
/export
```

**Keybind:** `ctrl+x x`

---

### [help](#help)

Show the help dialog.

```bash
/help
```

**Keybind:** `ctrl+x h`

---

### [init](#init)

Guided setup for creating or updating `AGENTS.md`. [Learn more](/docs/rules).

```bash
/init
```

**Keybind:** `ctrl+x i`

---

### [models](#models)

List available models.

```bash
/models
```

**Keybind:** `ctrl+x m`

---

### [new](#new)

Start a new session. *Alias*: `/clear`

```bash
/new
```

**Keybind:** `ctrl+x n`

---

### [redo](#redo)

Redo a previously undone message. Only available after using `/undo`.

> **Tip:** Any file changes will also be restored.

Internally, this uses Git to manage the file changes. So your project **needs to be a Git repository**.

```bash
/redo
```

**Keybind:** `ctrl+x r`

---

### [sessions](#sessions)

List and switch between sessions. *Aliases*: `/resume`, `/continue`

```bash
/sessions
```

**Keybind:** `ctrl+x l`

---

### [share](#share)

Share current session. [Learn more](/docs/share).

```bash
/share
```

**Keybind:** `ctrl+x s`

---

### [themes](#themes)

List available themes.

```bash
/themes
```

**Keybind:** `ctrl+x t`

---

### [thinking](#thinking)

Toggle the visibility of thinking/reasoning blocks in the conversation. When enabled, you can see the model’s reasoning process for models that support extended thinking.

> **Note:** This command only controls whether thinking blocks are **displayed** - it does not enable or disable the model’s reasoning capabilities. To toggle actual reasoning capabilities, use `ctrl+t` to cycle through model variants.

```bash
/thinking
```

---

### [undo](#undo)

Undo last message in the conversation. Removes the most recent user message, all subsequent responses, and any file changes.

> **Tip:** Any file changes made will also be reverted.

Internally, this uses Git to manage the file changes. So your project **needs to be a Git repository**.

```bash
/undo
```

**Keybind:** `ctrl+x u`

---

### [unshare](#unshare)

Unshare current session. [Learn more](/docs/share#un-sharing).

```bash
/unshare
```

---

## [Editor setup](#editor-setup)

Both the `/editor` and `/export` commands use the editor specified in your `EDITOR` environment variable.

 - [Linux/macOS](#tab-panel-4)
- [Windows (CMD)](#tab-panel-5)
- [Windows (PowerShell)](#tab-panel-6)

```bash
# Example for nano or vim
export EDITOR=nano
export EDITOR=vim

# For GUI editors, VS Code, Cursor, VSCodium, Windsurf, Zed, etc.
# include --wait
export EDITOR="code --wait"
```

To make it permanent, add this to your shell profile; `~/.bashrc`, `~/.zshrc`, etc.

```bash
set EDITOR=notepad

# For GUI editors, VS Code, Cursor, VSCodium, Windsurf, Zed, etc.
# include --wait
set EDITOR=code --wait
```

To make it permanent, use **System Properties** > **Environment Variables**.

```powershell
$env:EDITOR = "notepad"

# For GUI editors, VS Code, Cursor, VSCodium, Windsurf, Zed, etc.
# include --wait
$env:EDITOR = "code --wait"
```

To make it permanent, add this to your PowerShell profile.

Popular editor options include:

- `code` - Visual Studio Code

- `cursor` - Cursor

- `windsurf` - Windsurf

- `nvim` - Neovim editor

- `vim` - Vim editor

- `nano` - Nano editor

- `notepad` - Windows Notepad

- `subl` - Sublime Text

> **Note:** Some editors like VS Code need to be started with the `--wait` flag.

Some editors need command-line arguments to run in blocking mode. The `--wait` flag makes the editor process block until closed.

---

## [Configure](#configure)

You can customize TUI behavior through `tui.json` (or `tui.jsonc`).

// tui.json
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "theme": "opencode",
  "keybinds": {
    "leader": "ctrl+x"
  },
  "scroll_speed": 3,
  "scroll_acceleration": {
    "enabled": true
  },
  "diff_style": "auto"
}
```

This is separate from `opencode.json`, which configures server/runtime behavior.

### [Options](#options)

- `theme` - Sets your UI theme. [Learn more](/docs/themes).

- `keybinds` - Customizes keyboard shortcuts. [Learn more](/docs/keybinds).

- `scroll_acceleration.enabled` - Enable macOS-style scroll acceleration for smooth, natural scrolling. When enabled, scroll speed increases with rapid scrolling gestures and stays precise for slower movements. **This setting takes precedence over `scroll_speed` and overrides it when enabled.**

- `scroll_speed` - Controls how fast the TUI scrolls when using scroll commands (minimum: `0.001`, supports decimal values). Defaults to `3`. **Note: This is ignored if `scroll_acceleration.enabled` is set to `true`.**

- `diff_style` - Controls diff rendering. `"auto"` adapts to terminal width, `"stacked"` always shows a single-column layout.

Use `OPENCODE_TUI_CONFIG` to load a custom TUI config path.

---

## [Customization](#customization)

You can customize various aspects of the TUI view using the command palette (`ctrl+x h` or `/help`). These settings persist across restarts.

---

#### [Username display](#username-display)

Toggle whether your username appears in chat messages. Access this through:

- Command palette: Search for “username” or “hide username”

- The setting persists automatically and will be remembered across TUI sessions


---
# File: web.md
---
title: "Web"
source: "https://opencode.ai/docs/web/"
description: "Using OpenCode in your browser."
---

OpenCode can run as a web application in your browser, providing the same powerful AI coding experience without needing a terminal.

## [Getting Started](#getting-started)

Start the web interface by running:

```bash
opencode web
```

This starts a local server on `127.0.0.1` with a random available port and automatically opens OpenCode in your default browser.

> **Caution:** If `OPENCODE_SERVER_PASSWORD` is not set, the server will be unsecured. This is fine for local use but should be set for network access.

> **Tip:** For the best experience, run `opencode web` from [WSL](/docs/windows-wsl) rather than PowerShell. This ensures proper file system access and terminal integration.

---

## [Configuration](#configuration)

You can configure the web server using command line flags or in your [config file](/docs/config).

### [Port](#port)

By default, OpenCode picks an available port. You can specify a port:

```bash
opencode web --port 4096
```

### [Hostname](#hostname)

By default, the server binds to `127.0.0.1` (localhost only). To make OpenCode accessible on your network:

```bash
opencode web --hostname 0.0.0.0
```

When using `0.0.0.0`, OpenCode will display both local and network addresses:

```plaintext
  Local access:       http://localhost:4096
  Network access:     http://192.168.1.100:4096
```

### [mDNS Discovery](#mdns-discovery)

Enable mDNS to make your server discoverable on the local network:

```bash
opencode web --mdns
```

This automatically sets the hostname to `0.0.0.0` and advertises the server as `opencode.local`.

You can customize the mDNS domain name to run multiple instances on the same network:

```bash
opencode web --mdns --mdns-domain myproject.local
```

### [CORS](#cors)

To allow additional domains for CORS (useful for custom frontends):

```bash
opencode web --cors https://example.com
```

### [Authentication](#authentication)

To protect access, set a password using the `OPENCODE_SERVER_PASSWORD` environment variable:

```bash
OPENCODE_SERVER_PASSWORD=secret opencode web
```

The username defaults to `opencode` but can be changed with `OPENCODE_SERVER_USERNAME`.

---

## [Using the Web Interface](#using-the-web-interface)

Once started, the web interface provides access to your OpenCode sessions.

### [Sessions](#sessions)

View and manage your sessions from the homepage. You can see active sessions and start new ones.

### [Server Status](#server-status)

Click “See Servers” to view connected servers and their status.

---

## [Attaching a Terminal](#attaching-a-terminal)

You can attach a terminal TUI to a running web server:

```bash
# Start the web server
opencode web --port 4096

# In another terminal, attach the TUI
opencode attach http://localhost:4096
```

This allows you to use both the web interface and terminal simultaneously, sharing the same sessions and state.

---

## [Config File](#config-file)

You can also configure server settings in your `opencode.json` config file:

```json
{
  "server": {
    "port": 4096,
    "hostname": "0.0.0.0",
    "mdns": true,
    "cors": ["https://example.com"]
  }
}
```

Command line flags take precedence over config file settings.


---
# File: windows-wsl.md
---
title: "Windows (WSL)"
source: "https://opencode.ai/docs/windows-wsl/"
description: "Run OpenCode on Windows using WSL for the best experience."
---

While OpenCode can run directly on Windows, we recommend using [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) for the best experience. WSL provides a Linux environment that works seamlessly with OpenCode’s features.

> **Tip:** WSL offers better file system performance, full terminal support, and compatibility with development tools that OpenCode relies on.

---

## [Setup](#setup)

- **Install WSL** If you haven’t already, [install WSL](https://learn.microsoft.com/en-us/windows/wsl/install) using the official Microsoft guide.

- **Install OpenCode in WSL** Once WSL is set up, open your WSL terminal and install OpenCode using one of the [installation methods](/docs/). ```bash curl -fsSL https://opencode.ai/install | bash ```

- **Use OpenCode from WSL** Navigate to your project directory (access Windows files via `/mnt/c/`, `/mnt/d/`, etc.) and run OpenCode. ```bash cd /mnt/c/Users/YourName/project opencode ```

---

## [Desktop App + WSL Server](#desktop-app--wsl-server)

If you prefer using the OpenCode Desktop app but want to run the server in WSL:

- **Start the server in WSL** with `--hostname 0.0.0.0` to allow external connections: ```bash opencode serve --hostname 0.0.0.0 --port 4096 ```

- **Connect the Desktop app** to `http://localhost:4096`

> **Note:** If `localhost` does not work in your setup, connect using the WSL IP address instead (from WSL: `hostname -I`) and use `http://:4096`.

> **Caution:** When using `--hostname 0.0.0.0`, set `OPENCODE_SERVER_PASSWORD` to secure the server.

```bash
OPENCODE_SERVER_PASSWORD=your-password opencode serve --hostname 0.0.0.0
```

---

## [Web Client + WSL](#web-client--wsl)

For the best web experience on Windows:

- **Run `opencode web` in the WSL terminal** rather than PowerShell: ```bash opencode web --hostname 0.0.0.0 ```

- **Access from your Windows browser** at `http://localhost:` (OpenCode prints the URL)

Running `opencode web` from WSL ensures proper file system access and terminal integration while still being accessible from your Windows browser.

---

## [Accessing Windows Files](#accessing-windows-files)

WSL can access all your Windows files through the `/mnt/` directory:

- `C:` drive → `/mnt/c/`

- `D:` drive → `/mnt/d/`

- And so on…

Example:

```bash
cd /mnt/c/Users/YourName/Documents/project
opencode
```

> **Tip:** For the smoothest experience, consider cloning/copying your repo into the WSL filesystem (for example under `~/code/`) and running OpenCode there.

---

## [Tips](#tips)

- Keep OpenCode running in WSL for projects stored on Windows drives - file access is seamless

- Use VS Code’s [WSL extension](https://code.visualstudio.com/docs/remote/wsl) alongside OpenCode for an integrated development workflow

- Your OpenCode config and sessions are stored within the WSL environment at `~/.local/share/opencode/`


---
# File: zen.md
---
title: "Zen"
source: "https://opencode.ai/docs/zen/"
description: "Curated list of models provided by OpenCode."
---

OpenCode Zen is a list of tested and verified models provided by the OpenCode team.

> **Note:** OpenCode Zen is currently in beta.

Zen works like any other provider in OpenCode. You login to OpenCode Zen and get your API key. It’s **completely optional** and you don’t need to use it to use OpenCode.

---

## [Background](#background)

There are a large number of models out there but only a few of these models work well as coding agents. Additionally, most providers are configured very differently; so you get very different performance and quality.

> **Tip:** We tested a select group of models and providers that work well with OpenCode.

So if you are using a model through something like OpenRouter, you can never be sure if you are getting the best version of the model you want.

To fix this, we did a couple of things:

- We tested a select group of models and talked to their teams about how to best run them.

- We then worked with a few providers to make sure these were being served correctly.

- Finally, we benchmarked the combination of the model/provider and came up with a list that we feel good recommending.

OpenCode Zen is an AI gateway that gives you access to these models.

---

## [How it works](#how-it-works)

OpenCode Zen works like any other provider in OpenCode.

- You sign in to **[OpenCode Zen](https://opencode.ai/auth)**, add your billing details, and copy your API key.

- You run the `/connect` command in the TUI, select OpenCode Zen, and paste your API key.

- Run `/models` in the TUI to see the list of models we recommend.

You are charged per request and you can add credits to your account.

---

## [Endpoints](#endpoints)

You can also access our models through the following API endpoints.

ModelModel IDEndpointAI SDK PackageGPT 5.4gpt-5.4https://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.4 Progpt-5.4-prohttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.4 Minigpt-5.4-minihttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.4 Nanogpt-5.4-nanohttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.3 Codexgpt-5.3-codexhttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.3 Codex Sparkgpt-5.3-codex-sparkhttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.2gpt-5.2https://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.2 Codexgpt-5.2-codexhttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.1gpt-5.1https://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.1 Codexgpt-5.1-codexhttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.1 Codex Maxgpt-5.1-codex-maxhttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5.1 Codex Minigpt-5.1-codex-minihttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5gpt-5https://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5 Codexgpt-5-codexhttps://opencode.ai/zen/v1/responses@ai-sdk/openaiGPT 5 Nanogpt-5-nanohttps://opencode.ai/zen/v1/responses@ai-sdk/openaiClaude Opus 4.6claude-opus-4-6https://opencode.ai/zen/v1/messages@ai-sdk/anthropicClaude Opus 4.5claude-opus-4-5https://opencode.ai/zen/v1/messages@ai-sdk/anthropicClaude Opus 4.1claude-opus-4-1https://opencode.ai/zen/v1/messages@ai-sdk/anthropicClaude Sonnet 4.6claude-sonnet-4-6https://opencode.ai/zen/v1/messages@ai-sdk/anthropicClaude Sonnet 4.5claude-sonnet-4-5https://opencode.ai/zen/v1/messages@ai-sdk/anthropicClaude Sonnet 4claude-sonnet-4https://opencode.ai/zen/v1/messages@ai-sdk/anthropicClaude Haiku 4.5claude-haiku-4-5https://opencode.ai/zen/v1/messages@ai-sdk/anthropicClaude Haiku 3.5claude-3-5-haikuhttps://opencode.ai/zen/v1/messages@ai-sdk/anthropicGemini 3.1 Progemini-3.1-prohttps://opencode.ai/zen/v1/models/gemini-3.1-pro@ai-sdk/googleGemini 3 Flashgemini-3-flashhttps://opencode.ai/zen/v1/models/gemini-3-flash@ai-sdk/googleMiniMax M2.5minimax-m2.5https://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleMiniMax M2.5 Freeminimax-m2.5-freehttps://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleGLM 5glm-5https://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleKimi K2.5kimi-k2.5https://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleBig Picklebig-picklehttps://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleMiMo V2 Pro Freemimo-v2-pro-freehttps://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleMiMo V2 Omni Freemimo-v2-omni-freehttps://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleQwen3.6 Plus Freeqwen3.6-plus-freehttps://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatibleNemotron 3 Super Freenemotron-3-super-freehttps://opencode.ai/zen/v1/chat/completions@ai-sdk/openai-compatible

The [model id](/docs/config/#models) in your OpenCode config uses the format `opencode/`. For example, for GPT 5.3 Codex, you would use `opencode/gpt-5.3-codex` in your config.

---

### [Models](#models)

You can fetch the full list of available models and their metadata from:

```plaintext
https://opencode.ai/zen/v1/models
```

---

## [Pricing](#pricing)

We support a pay-as-you-go model. Below are the prices **per 1M tokens**.

ModelInputOutputCached ReadCached WriteBig PickleFreeFreeFree-MiMo V2 Pro FreeFreeFreeFree-MiMo V2 Omni FreeFreeFreeFree-Qwen3.6 Plus FreeFreeFreeFree-Nemotron 3 Super FreeFreeFreeFree-MiniMax M2.5 FreeFreeFreeFree-MiniMax M2.5$0.30$1.20$0.06$0.375GLM 5$1.00$3.20$0.20-Kimi K2.5$0.60$3.00$0.10-Qwen3 Coder 480B$0.45$1.50--Claude Opus 4.6$5.00$25.00$0.50$6.25Claude Opus 4.5$5.00$25.00$0.50$6.25Claude Opus 4.1$15.00$75.00$1.50$18.75Claude Sonnet 4.6$3.00$15.00$0.30$3.75Claude Sonnet 4.5 (≤ 200K tokens)$3.00$15.00$0.30$3.75Claude Sonnet 4.5 (> 200K tokens)$6.00$22.50$0.60$7.50Claude Sonnet 4 (≤ 200K tokens)$3.00$15.00$0.30$3.75Claude Sonnet 4 (> 200K tokens)$6.00$22.50$0.60$7.50Claude Haiku 4.5$1.00$5.00$0.10$1.25Claude Haiku 3.5$0.80$4.00$0.08$1.00Gemini 3.1 Pro (≤ 200K tokens)$2.00$12.00$0.20-Gemini 3.1 Pro (> 200K tokens)$4.00$18.00$0.40-Gemini 3 Flash$0.50$3.00$0.05-GPT 5.4$2.50$15.00$0.25-GPT 5.4 Pro$30.00$180.00$30.00-GPT 5.4 Mini$0.75$4.50$0.075-GPT 5.4 Nano$0.20$1.25$0.02-GPT 5.3 Codex Spark$1.75$14.00$0.175-GPT 5.3 Codex$1.75$14.00$0.175-GPT 5.2$1.75$14.00$0.175-GPT 5.2 Codex$1.75$14.00$0.175-GPT 5.1$1.07$8.50$0.107-GPT 5.1 Codex$1.07$8.50$0.107-GPT 5.1 Codex Max$1.25$10.00$0.125-GPT 5.1 Codex Mini$0.25$2.00$0.025-GPT 5$1.07$8.50$0.107-GPT 5 Codex$1.07$8.50$0.107-GPT 5 NanoFreeFreeFree-

You might notice *Claude Haiku 3.5* in your usage history. This is a [low cost model](/docs/config/#models) that’s used to generate the titles of your sessions.

> **Note:** Credit card fees are passed along at cost (4.4% + $0.30 per transaction); we don’t charge anything beyond that.

The free models:

- MiniMax M2.5 Free is available on OpenCode for a limited time. The team is using this time to collect feedback and improve the model.

- MiMo V2 Pro Free is available on OpenCode for a limited time. The team is using this time to collect feedback and improve the model.

- MiMo V2 Omni Free is available on OpenCode for a limited time. The team is using this time to collect feedback and improve the model.

- Qwen3.6 Plus Free is available on OpenCode for a limited time. The team is using this time to collect feedback and improve the model.

- Nemotron 3 Super Free is available on OpenCode for a limited time. The team is using this time to collect feedback and improve the model.

- Big Pickle is a stealth model that’s free on OpenCode for a limited time. The team is using this time to collect feedback and improve the model.

[Contact us](mailto:contact@anoma.ly) if you have any questions.

---

### [Auto-reload](#auto-reload)

If your balance goes below $5, Zen will automatically reload $20.

You can change the auto-reload amount. You can also disable auto-reload entirely.

---

### [Monthly limits](#monthly-limits)

You can also set a monthly usage limit for the entire workspace and for each member of your team.

For example, let’s say you set a monthly usage limit to $20, Zen will not use more than $20 in a month. But if you have auto-reload enabled, Zen might end up charging you more than $20 if your balance goes below $5.

---

### [Deprecated models](#deprecated-models)

ModelDeprecation dateMiniMax M2.1March 15, 2026GLM 4.7March 15, 2026GLM 4.6March 15, 2026Gemini 3 ProMarch 9, 2026Kimi K2 ThinkingMarch 6, 2026Kimi K2March 6, 2026Qwen3 Coder 480BFeb 6, 2026

---

## [Privacy](#privacy)

All our models are hosted in the US. Our providers follow a zero-retention policy and do not use your data for model training, with the following exceptions:

- Big Pickle: During its free period, collected data may be used to improve the model.

- MiniMax M2.5 Free: During its free period, collected data may be used to improve the model.

- MiMo V2 Pro Free: During its free period, collected data may be used to improve the model.

- MiMo V2 Omni Free: During its free period, collected data may be used to improve the model.

- Qwen3.6 Plus Free: During its free period, collected data may be used to improve the model.

- Nemotron 3 Super Free: During its free period, collected data may be used to improve the model.

- OpenAI APIs: Requests are retained for 30 days in accordance with [OpenAI’s Data Policies](https://platform.openai.com/docs/guides/your-data).

- Anthropic APIs: Requests are retained for 30 days in accordance with [Anthropic’s Data Policies](https://docs.anthropic.com/en/docs/claude-code/data-usage).

---

## [For Teams](#for-teams)

Zen also works great for teams. You can invite teammates, assign roles, curate the models your team uses, and more.

> **Note:** Workspaces are currently free for teams as a part of the beta.

Managing your workspace is currently free for teams as a part of the beta. We’ll be sharing more details on the pricing soon.

---

### [Roles](#roles)

You can invite teammates to your workspace and assign roles:

- **Admin**: Manage models, members, API keys, and billing

- **Member**: Manage only their own API keys

Admins can also set monthly spending limits for each member to keep costs under control.

---

### [Model access](#model-access)

Admins can enable or disable specific models for the workspace. Requests made to a disabled model will return an error.

This is useful for cases where you want to disable the use of a model that collects data.

---

### [Bring your own key](#bring-your-own-key)

You can use your own OpenAI or Anthropic API keys while still accessing other models in Zen.

When you use your own keys, tokens are billed directly by the provider, not by Zen.

For example, your organization might already have a key for OpenAI or Anthropic and you want to use that instead of the one that Zen provides.

---

## [Goals](#goals)

We created OpenCode Zen to:

- **Benchmark** the best models/providers for coding agents.

- Have access to the **highest quality** options and not downgrade performance or route to cheaper providers.

- Pass along any **price drops** by selling at cost; so the only markup is to cover our processing fees.

- Have **no lock-in** by allowing you to use it with any other coding agent. And always let you use any other provider with OpenCode as well.

