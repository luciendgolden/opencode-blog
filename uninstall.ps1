#!/usr/bin/env pwsh
# opencode-blog uninstaller for Windows

$ErrorActionPreference = "Stop"

function Write-Color($Color, $Text) {
    Write-Host $Text -ForegroundColor $Color
}

$OpenCodeDir = Join-Path $env:USERPROFILE ".config" "opencode"
$SkillDir    = Join-Path $OpenCodeDir "skills"
$AgentDir    = Join-Path $OpenCodeDir "agents"
$CommandDir  = Join-Path $OpenCodeDir "commands"

Write-Color Cyan "=== Uninstalling opencode-blog ==="
Write-Host ""

# Remove main skill (includes references, templates, scripts)
$blogSkill = Join-Path $SkillDir "blog"
if (Test-Path $blogSkill) {
    Remove-Item -Recurse -Force $blogSkill
    Write-Color Green "  Removed: $blogSkill"
}

# Remove sub-skills (auto-discovers all blog-* directories)
Get-ChildItem -Directory $SkillDir -Filter "blog-*" -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item -Recurse -Force $_.FullName
    Write-Color Green "  Removed: $($_.FullName)"
}

# Remove agents (primary + subagents)
foreach ($agent in @("blog", "blog-researcher", "blog-writer", "blog-seo", "blog-reviewer")) {
    $path = Join-Path $AgentDir "${agent}.md"
    if (Test-Path $path) {
        Remove-Item -Force $path
        Write-Color Green "  Removed: $path"
    }
}

# Remove commands
$cmdPath = Join-Path $CommandDir "blog.md"
if (Test-Path $cmdPath) {
    Remove-Item -Force $cmdPath
    Write-Color Green "  Removed: $cmdPath"
}

Write-Host ""
Write-Color Cyan "=== opencode-blog uninstalled ==="
Write-Host ""
Write-Host "Restart OpenCode to complete removal."
