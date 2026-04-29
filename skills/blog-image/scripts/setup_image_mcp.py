#!/usr/bin/env python3
"""
Setup script for nanobanana-mcp in opencode-blog.

Configures @ycse/nanobanana-mcp inside the project's opencode.json (default)
or the global ~/.config/opencode/opencode.json (with --global). MCP entries
are written under the `mcp` key, matching OpenCode's config schema.

Usage:
    python3 setup_image_mcp.py                    # Interactive (prompts for key)
    python3 setup_image_mcp.py --key YOUR_KEY     # Non-interactive
    python3 setup_image_mcp.py --check            # Verify existing setup
    python3 setup_image_mcp.py --remove           # Remove MCP config
    python3 setup_image_mcp.py --global           # Write to ~/.config/opencode/opencode.json
    python3 setup_image_mcp.py --help             # Show usage
"""

import json
import os
import sys
from pathlib import Path

MCP_NAME = "nanobanana-mcp"
MCP_PACKAGE = "@ycse/nanobanana-mcp"
DEFAULT_MODEL = "gemini-3.1-flash-image-preview"

GLOBAL_OPENCODE_PATH = Path.home() / ".config" / "opencode" / "opencode.json"


def find_project_opencode_json() -> Path:
    """Walk up from this script and from cwd to find a project opencode.json."""
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


def get_config_path(use_global: bool) -> Path:
    """Return the opencode.json the script should edit."""
    if use_global:
        return GLOBAL_OPENCODE_PATH
    project_path = find_project_opencode_json()
    if project_path:
        return project_path
    print("Note: no project-level opencode.json found.")
    print("      Falling back to the global config.")
    return GLOBAL_OPENCODE_PATH


def load_config(path: Path) -> dict:
    """Load a config file. Returns {} if missing."""
    if not path.exists():
        return {}
    with open(path, "r") as f:
        return json.load(f)


def save_config(path: Path, config: dict) -> None:
    """Save a config file."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w") as f:
        json.dump(config, f, indent=2)
        f.write("\n")
    print(f"Config saved to {path}")


def _ensure_mcp_dict(config: dict) -> dict:
    """Make sure config['mcp'] exists and is a dict, return it."""
    if not isinstance(config.get("mcp"), dict):
        config["mcp"] = {}
    return config["mcp"]


def check_setup(use_global: bool) -> bool:
    """Check whether the MCP entry is configured."""
    paths_to_check = []
    if not use_global:
        project_path = find_project_opencode_json()
        if project_path:
            paths_to_check.append(("project opencode.json", project_path))
    paths_to_check.append(("global opencode.json", GLOBAL_OPENCODE_PATH))

    for label, path in paths_to_check:
        config = load_config(path)
        servers = config.get("mcp", {}) or {}
        if MCP_NAME in servers:
            env = servers[MCP_NAME].get("environment", {}) or {}
            key = env.get("GOOGLE_AI_API_KEY", "")
            masked = key[:8] + "..." + key[-4:] if len(key) > 12 else "(not set)"
            print(f"MCP server '{MCP_NAME}' found in {label}.")
            print(f"  Path:    {path}")
            print(f"  Package: {MCP_PACKAGE}")
            print(f"  API Key: {masked}")
            print(f"  Model:   {env.get('NANOBANANA_MODEL', DEFAULT_MODEL)}")
            return True

    print(f"MCP server '{MCP_NAME}' is NOT configured.")
    return False


def remove_mcp(use_global: bool) -> None:
    """Remove the MCP configuration entry."""
    path = get_config_path(use_global)
    config = load_config(path)
    servers = config.get("mcp", {}) or {}
    if MCP_NAME in servers:
        del servers[MCP_NAME]
        config["mcp"] = servers
        save_config(path, config)
        print(f"Removed '{MCP_NAME}' from {path}.")
    else:
        print(f"'{MCP_NAME}' not found in {path}.")


def setup_mcp(api_key: str, use_global: bool) -> None:
    """Configure the MCP server entry."""
    if not api_key or not api_key.strip():
        print("Error: API key cannot be empty.")
        sys.exit(1)

    api_key = api_key.strip()
    path = get_config_path(use_global)
    config = load_config(path)
    servers = _ensure_mcp_dict(config)

    servers[MCP_NAME] = {
        "type": "local",
        "command": ["npx", "-y", MCP_PACKAGE],
        "enabled": True,
        "environment": {
            "GOOGLE_AI_API_KEY": api_key,
            "NANOBANANA_MODEL": DEFAULT_MODEL,
        },
    }

    save_config(path, config)
    print(f"\nMCP server '{MCP_NAME}' configured successfully!")
    print(f"  Package: {MCP_PACKAGE}")
    print(f"  Model:   {DEFAULT_MODEL}")
    print(f"  Config:  {path}")
    print("\nRestart OpenCode (or reload the TUI) for changes to take effect.")
    print("Generated images will be saved to: ~/Documents/nanobanana_generated/")


def main() -> None:
    args = sys.argv[1:]
    use_global = "--global" in args

    if "--help" in args or "-h" in args:
        print("Usage: python3 setup_image_mcp.py [OPTIONS]")
        print()
        print("Options:")
        print("  --key KEY        Provide API key non-interactively")
        print("  --check          Verify existing setup")
        print("  --remove         Remove MCP configuration")
        print("  --global         Write to ~/.config/opencode/opencode.json (default: project opencode.json)")
        print("  --help, -h       Show this help message")
        print()
        print("Get a free API key at: https://aistudio.google.com/apikey")
        sys.exit(0)

    if "--check" in args:
        check_setup(use_global)
        return

    if "--remove" in args:
        remove_mcp(use_global)
        return

    # Get API key
    api_key = None
    for i, arg in enumerate(args):
        if arg == "--key" and i + 1 < len(args):
            api_key = args[i + 1]
            break

    if not api_key:
        api_key = os.environ.get("GOOGLE_AI_API_KEY")

    if not api_key:
        print("opencode-blog - Image Generation MCP Setup")
        print("=" * 46)
        print("\nGet your free API key at: https://aistudio.google.com/apikey")
        print()
        try:
            api_key = input("Enter your Google AI API key: ")
        except (EOFError, KeyboardInterrupt):
            print("\nError: No input received. Provide a key with --key or set GOOGLE_AI_API_KEY env var.")
            sys.exit(1)

    setup_mcp(api_key, use_global)


if __name__ == "__main__":
    main()
