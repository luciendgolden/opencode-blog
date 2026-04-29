#!/usr/bin/env python3
"""
Validate that nanobanana-mcp is properly configured for opencode-blog.

Checks project opencode.json (mcp section) first, then falls back to the
global ~/.config/opencode/opencode.json. Legacy ~/.claude/settings.json /
project .mcp.json paths are checked last so existing setups still validate.

Checks:
1. Config file has the MCP entry
2. API key is present
3. Node.js/npx is available
4. Output directory exists or can be created

Usage:
    python3 validate_image_setup.py
"""

import json
import shutil
import sys
from pathlib import Path

MCP_NAME = "nanobanana-mcp"
OUTPUT_DIR = Path.home() / "Documents" / "nanobanana_generated"

OPENCODE_GLOBAL_CONFIG = Path.home() / ".config" / "opencode" / "opencode.json"
LEGACY_CLAUDE_GLOBAL = Path.home() / ".claude" / "settings.json"


def find_project_opencode_json() -> Path:
    """Find a project-level opencode.json by walking up from this script."""
    for start in (Path(__file__).resolve().parent, Path.cwd()):
        current = start
        for _ in range(10):
            candidate = current / "opencode.json"
            if candidate.exists():
                return candidate
            parent = current.parent
            if parent == current:
                break
            current = parent
    return None


def find_project_legacy_mcp_json() -> Path:
    """Legacy fallback: project-level .mcp.json from the Claude Code era."""
    for start in (Path(__file__).resolve().parent, Path.cwd()):
        current = start
        for _ in range(10):
            candidate = current / ".mcp.json"
            if candidate.exists():
                return candidate
            parent = current.parent
            if parent == current:
                break
            current = parent
    return None


def _extract_servers(config: dict) -> dict:
    """opencode.json uses `mcp`; Claude Code used `mcpServers`. Return either."""
    if isinstance(config.get("mcp"), dict):
        return config["mcp"]
    return config.get("mcpServers", {}) or {}


def check(label: str, passed: bool, detail: str = "") -> bool:
    status = "PASS" if passed else "FAIL"
    msg = f"  [{status}] {label}"
    if detail:
        msg += f" - {detail}"
    print(msg)
    return passed


def find_mcp_config() -> tuple:
    """Find MCP config in project or global settings. Returns (config_dict, path_label)."""
    # 1. Project opencode.json (preferred)
    project_path = find_project_opencode_json()
    if project_path:
        try:
            with open(project_path) as f:
                config = json.load(f)
            if MCP_NAME in _extract_servers(config):
                return config, f"project opencode.json ({project_path})"
        except (json.JSONDecodeError, OSError):
            pass

    # 2. Global opencode config
    if OPENCODE_GLOBAL_CONFIG.exists():
        try:
            with open(OPENCODE_GLOBAL_CONFIG) as f:
                config = json.load(f)
            if MCP_NAME in _extract_servers(config):
                return config, f"global opencode config ({OPENCODE_GLOBAL_CONFIG})"
        except (json.JSONDecodeError, OSError):
            pass

    # 3. Legacy project .mcp.json (Claude Code era)
    legacy_project = find_project_legacy_mcp_json()
    if legacy_project:
        try:
            with open(legacy_project) as f:
                config = json.load(f)
            if MCP_NAME in _extract_servers(config):
                return config, f"legacy project .mcp.json ({legacy_project})"
        except (json.JSONDecodeError, OSError):
            pass

    # 4. Legacy global Claude Code settings
    if LEGACY_CLAUDE_GLOBAL.exists():
        try:
            with open(LEGACY_CLAUDE_GLOBAL) as f:
                config = json.load(f)
            if MCP_NAME in _extract_servers(config):
                return config, f"legacy global settings ({LEGACY_CLAUDE_GLOBAL})"
        except (json.JSONDecodeError, OSError):
            pass

    return None, None


def main() -> int:
    print("opencode-blog - Image Generation Setup Validation")
    print("=" * 50)
    results = []

    # 1-2. Find and load config
    config, config_label = find_mcp_config()

    if config is None:
        results.append(check(
            "MCP config found",
            False,
            "Not found in project opencode.json, ~/.config/opencode/opencode.json, or any legacy .mcp.json/settings.json",
        ))
        print(f"\nRun: python3 scripts/setup_image_mcp.py --key YOUR_KEY")
        return 1

    results.append(check("MCP config found", True, config_label))

    # 3. MCP entry exists (opencode.json -> mcp ; legacy -> mcpServers)
    servers = _extract_servers(config)
    has_mcp = MCP_NAME in servers
    results.append(check(f"MCP server '{MCP_NAME}' configured", has_mcp))

    if has_mcp:
        mcp = servers[MCP_NAME]

        # 4. Command is npx. opencode uses command: ["npx", ...]; legacy used command: "npx" + args.
        cmd_field = mcp.get("command")
        if isinstance(cmd_field, list):
            cmd_head = cmd_field[0] if cmd_field else None
        else:
            cmd_head = cmd_field
        results.append(check(
            "Command is 'npx'",
            cmd_head == "npx",
            str(cmd_field) if cmd_field is not None else "(missing)",
        ))

        # 5. Package is correct (opencode embeds it in `command`; legacy used `args`)
        if isinstance(cmd_field, list):
            args = cmd_field[1:]
        else:
            args = mcp.get("args", [])
        has_pkg = "@ycse/nanobanana-mcp" in args
        results.append(check(
            "Package is @ycse/nanobanana-mcp",
            has_pkg,
            str(args),
        ))

        # 6. API key present (opencode uses `environment`; legacy used `env`)
        env = mcp.get("environment") or mcp.get("env") or {}
        key = env.get("GOOGLE_AI_API_KEY", "")
        # Accept env var placeholders as configured, but warn about ${} syntax
        key_set = bool(key) and key != ""
        is_placeholder = key.startswith("${") and key.endswith("}")
        if is_placeholder:
            results.append(check(
                "GOOGLE_AI_API_KEY is set",
                True,
                f"{key} (env var placeholder - ensure this variable is exported in your shell)",
            ))
        else:
            results.append(check(
                "GOOGLE_AI_API_KEY is set",
                key_set,
                f"{key[:8]}...{key[-4:]}" if len(key) > 12 else key or "(empty)",
            ))

        # 7. Model configured (optional - package has a default)
        model = env.get("NANOBANANA_MODEL", "")
        results.append(check(
            "NANOBANANA_MODEL is set",
            True,  # Always pass - model is optional, package defaults to gemini-3.1-flash
            model or "(not set - package will use default model)",
        ))

    # 8. Node.js/npx available
    has_npx = shutil.which("npx") is not None
    results.append(check(
        "npx is available in PATH",
        has_npx,
        shutil.which("npx") or "not found - install Node.js 18+",
    ))

    # 9. Output directory
    if OUTPUT_DIR.exists():
        results.append(check("Output directory exists", True, str(OUTPUT_DIR)))
    else:
        try:
            OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
            results.append(check("Output directory created", True, str(OUTPUT_DIR)))
        except OSError as e:
            results.append(check("Output directory writable", False, str(e)))

    # Summary
    passed = sum(1 for r in results if r)
    total = len(results)
    print(f"\n{'=' * 48}")
    print(f"Results: {passed}/{total} checks passed")

    if passed == total:
        print("Status: Ready to generate blog images!")
        return 0
    else:
        print("Status: Some checks failed. Fix the issues above.")
        print("Setup: python3 scripts/setup_image_mcp.py --key YOUR_KEY")
        return 1


if __name__ == "__main__":
    sys.exit(main())
