#!/usr/bin/env bash
set -euo pipefail

# opencode-blog uninstaller
# Cleanly removes all blog skills, agents, commands, and analyzer scripts.

main() {
    local OPENCODE_DIR="${HOME}/.config/opencode"
    local SKILL_DIR="${OPENCODE_DIR}/skills"
    local AGENT_DIR="${OPENCODE_DIR}/agents"
    local COMMAND_DIR="${OPENCODE_DIR}/commands"

    echo "=== Uninstalling opencode-blog ==="
    echo ""

    # Remove main skill (includes references, templates, scripts)
    if [ -d "${SKILL_DIR}/blog" ]; then
        rm -rf "${SKILL_DIR}/blog"
        echo "  Removed: ${SKILL_DIR}/blog/"
    fi

    # Remove sub-skills (auto-discovers all blog-* directories)
    for skill_dir in "${SKILL_DIR}"/blog-*; do
        if [ -d "${skill_dir}" ]; then
            rm -rf "${skill_dir}"
            echo "  Removed: ${skill_dir}/"
        fi
    done

    # Remove agents (primary + subagents)
    for agent in blog blog-researcher blog-writer blog-seo blog-reviewer; do
        if [ -f "${AGENT_DIR}/${agent}.md" ]; then
            rm -f "${AGENT_DIR}/${agent}.md"
            echo "  Removed: ${AGENT_DIR}/${agent}.md"
        fi
    done

    # Remove commands
    if [ -f "${COMMAND_DIR}/blog.md" ]; then
        rm -f "${COMMAND_DIR}/blog.md"
        echo "  Removed: ${COMMAND_DIR}/blog.md"
    fi

    echo ""
    echo "=== opencode-blog uninstalled ==="
    echo ""
    echo "Restart OpenCode to complete removal."
}

main "$@"
