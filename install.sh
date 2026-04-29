#!/usr/bin/env bash
set -euo pipefail

# opencode-blog installer
# Installs the blog skill ecosystem to ~/.config/opencode/{skills,agents,commands}.
#
# One-command install:
#   curl -fsSL https://raw.githubusercontent.com/AgriciDaniel/opencode-blog/main/install.sh | bash

# Declared outside main() so the EXIT trap can access it after main() returns
TEMP_DIR=""

main() {
    local OPENCODE_DIR="${HOME}/.config/opencode"
    local SKILL_DIR="${OPENCODE_DIR}/skills"
    local AGENT_DIR="${OPENCODE_DIR}/agents"
    local COMMAND_DIR="${OPENCODE_DIR}/commands"
    local SCRIPT_DIR

    echo ""
    echo "  ╔═════════════════════════════════════════╗"
    echo "  ║         opencode-blog Installer         ║"
    echo "  ║   Blog Content Engine for OpenCode      ║"
    echo "  ╚═════════════════════════════════════════╝"
    echo ""

    # Determine source directory (local clone or piped from curl)
    if [ -f "${BASH_SOURCE[0]:-}" ] && [ -d "$(dirname "${BASH_SOURCE[0]}")/skills/blog" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    else
        echo "→ Cloning opencode-blog..."
        TEMP_DIR="$(mktemp -d)"
        trap 'rm -rf "${TEMP_DIR}"' EXIT
        git clone --depth 1 https://github.com/AgriciDaniel/opencode-blog.git "${TEMP_DIR}/opencode-blog" 2>/dev/null
        SCRIPT_DIR="${TEMP_DIR}/opencode-blog"
    fi

    # Check prerequisites
    if ! command -v python3 &>/dev/null; then
        echo "WARNING: python3 not found. The analyze_blog.py script requires Python 3.11+."
        echo "         Install with your package manager (e.g. brew install python@3.12)."
        echo ""
    fi

    # Create directories
    echo "→ Creating directories..."
    mkdir -p "${SKILL_DIR}/blog/references"
    mkdir -p "${SKILL_DIR}/blog/templates"
    mkdir -p "${SKILL_DIR}/blog/scripts"
    mkdir -p "${AGENT_DIR}"
    mkdir -p "${COMMAND_DIR}"

    # Copy main skill
    echo "→ Installing blog knowledge skill..."
    cp "${SCRIPT_DIR}/skills/blog/SKILL.md" "${SKILL_DIR}/blog/SKILL.md"

    # Copy references
    if ls "${SCRIPT_DIR}/skills/blog/references/"*.md &>/dev/null; then
        echo "→ Installing reference files..."
        cp "${SCRIPT_DIR}/skills/blog/references/"*.md "${SKILL_DIR}/blog/references/"
    fi

    # Copy templates
    if ls "${SCRIPT_DIR}/skills/blog/templates/"*.md &>/dev/null; then
        echo "→ Installing content templates..."
        cp "${SCRIPT_DIR}/skills/blog/templates/"*.md "${SKILL_DIR}/blog/templates/"
    fi

    # Copy sub-skills (auto-discovers all skill directories)
    echo "→ Installing sub-skills..."
    for skill_dir in "${SCRIPT_DIR}/skills/"*/; do
        skill_name="$(basename "${skill_dir}")"
        [ "$skill_name" = "blog" ] && continue
        mkdir -p "${SKILL_DIR}/${skill_name}"
        if [ -f "${skill_dir}SKILL.md" ]; then
            cp "${skill_dir}SKILL.md" "${SKILL_DIR}/${skill_name}/SKILL.md"
            echo "  + ${skill_name}"
        fi
        if [ -d "${skill_dir}references" ]; then
            mkdir -p "${SKILL_DIR}/${skill_name}/references"
            cp "${skill_dir}references/"* "${SKILL_DIR}/${skill_name}/references/" 2>/dev/null || true
        fi
        if [ -d "${skill_dir}scripts" ]; then
            mkdir -p "${SKILL_DIR}/${skill_name}/scripts"
            cp "${skill_dir}scripts/"* "${SKILL_DIR}/${skill_name}/scripts/" 2>/dev/null || true
            chmod +x "${SKILL_DIR}/${skill_name}/scripts/"*.py 2>/dev/null || true
        fi
        if [ -d "${skill_dir}assets" ]; then
            mkdir -p "${SKILL_DIR}/${skill_name}/assets"
            cp -R "${skill_dir}assets/"* "${SKILL_DIR}/${skill_name}/assets/" 2>/dev/null || true
        fi
    done

    # Create personas directory for blog-persona
    mkdir -p "${SKILL_DIR}/blog/references/personas"

    # Copy agents (primary + subagents)
    echo "→ Installing agents..."
    for agent_file in "${SCRIPT_DIR}/agents/"*.md; do
        if [ -f "${agent_file}" ]; then
            agent_name="$(basename "${agent_file}")"
            cp "${agent_file}" "${AGENT_DIR}/${agent_name}"
            echo "  + ${agent_name%.md}"
        fi
    done

    # Copy commands
    echo "→ Installing slash commands..."
    if [ -d "${SCRIPT_DIR}/commands" ]; then
        for cmd_file in "${SCRIPT_DIR}/commands/"*.md; do
            if [ -f "${cmd_file}" ]; then
                cmd_name="$(basename "${cmd_file}")"
                cp "${cmd_file}" "${COMMAND_DIR}/${cmd_name}"
                echo "  + /${cmd_name%.md}"
            fi
        done
    fi

    # Copy analyzer script
    echo "→ Installing analyzer script..."
    cp "${SCRIPT_DIR}/scripts/analyze_blog.py" "${SKILL_DIR}/blog/scripts/analyze_blog.py"
    chmod +x "${SKILL_DIR}/blog/scripts/analyze_blog.py"

    # Install Python dependencies
    if [ -f "${SCRIPT_DIR}/requirements.txt" ] && command -v pip3 &>/dev/null; then
        echo "→ Installing Python dependencies..."
        pip3 install --quiet -r "${SCRIPT_DIR}/requirements.txt" 2>/dev/null || \
            echo "  Skipped: install manually with 'pip3 install -r requirements.txt'"
        echo "  Tip: consider a venv -- python3 -m venv .venv && source .venv/bin/activate"
    fi

    echo ""
    echo "  ╔═════════════════════════════════════════╗"
    echo "  ║       Installation Complete!            ║"
    echo "  ╚═════════════════════════════════════════╝"
    echo ""
    echo "  Installed to ${OPENCODE_DIR}:"
    echo "    skills/blog/        Knowledge skill (references + templates + analyzer)"
    echo "    skills/blog-*       21 sub-skills"
    echo "    agents/blog.md      Primary orchestrator agent"
    echo "    agents/blog-*       4 specialist subagents"
    echo "    commands/blog.md    /blog slash command"
    echo ""
    echo "  Try in OpenCode TUI:"
    echo "    /blog write <topic>          Write a new blog post"
    echo "    /blog rewrite <file>         Optimize an existing post"
    echo "    /blog analyze <file>         Quality audit (0-100 score)"
    echo "    /blog brief <topic>          Content brief"
    echo "    /blog calendar               Editorial calendar"
    echo "    /blog strategy <niche>       Strategy + topic ideation"
    echo "    /blog outline <topic>        SERP-informed outline"
    echo "    /blog seo-check <file>       SEO validation"
    echo "    /blog schema <file>          JSON-LD schema"
    echo "    /blog repurpose <file>       Cross-platform repurposing"
    echo "    /blog geo <file>             AI citation readiness audit"
    echo "    /blog image <idea>           Gemini image generation"
    echo "    /blog audit [directory]      Full-site assessment"
    echo "    /blog cannibalization        Detect keyword overlap"
    echo "    /blog factcheck              Verify statistics"
    echo "    /blog persona                Manage personas"
    echo "    /blog taxonomy               CMS taxonomy management"
    echo "    /blog notebooklm <q>         NotebookLM research"
    echo "    /blog audio <file>           Gemini TTS narration"
    echo "    /blog google [cmd] [args]    PSI/CrUX/GSC/GA4/NLP/YouTube/Keywords"
    echo ""
    echo "  Optional: AI features need a free Google AI API key"
    echo "    /blog image setup            Configure Gemini image generation"
    echo "    /blog audio setup            Configure Gemini TTS"
    echo "    Get your key:                https://aistudio.google.com/apikey"
    echo ""
    echo "  Restart OpenCode (or reload the TUI) to pick up the new skills,"
    echo "  agents, and commands."
}

main "$@"
