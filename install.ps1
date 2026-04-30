#!/usr/bin/env pwsh
# opencode-blog installer for Windows
# Installs the blog skill ecosystem to %USERPROFILE%\.config\opencode\{skills,agents,commands}.
#
# One-command install:
#   iex (irm https://raw.githubusercontent.com/AgriciDaniel/opencode-blog/main/install.ps1)

$ErrorActionPreference = "Stop"

function Write-Color($Color, $Text) {
    Write-Host $Text -ForegroundColor $Color
}

function Main {
    Write-Color Cyan @"

   ╔═════════════════════════════════════════╗
   ║         opencode-blog Installer         ║
   ║   Blog Content Engine for OpenCode      ║
   ╚═════════════════════════════════════════╝

"@

    $OpenCodeDir = Join-Path $env:USERPROFILE ".config" "opencode"
    $SkillDir   = Join-Path $OpenCodeDir "skills"
    $AgentDir   = Join-Path $OpenCodeDir "agents"
    $CommandDir = Join-Path $OpenCodeDir "commands"
    $TempDir    = $null

    # Determine source directory (local clone or piped from irm)
    if ($MyInvocation.MyCommand.Path -and (Test-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "skills" "blog"))) {
        $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    } else {
        Write-Color White "Cloning opencode-blog..."
        $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "opencode-blog-install-$([System.Guid]::NewGuid().ToString('N').Substring(0,8))"
        git clone --depth 1 https://github.com/AgriciDaniel/opencode-blog.git $TempDir 2>$null
        $ScriptDir = $TempDir
    }

    # Check prerequisites
    try {
        $null = Get-Command python3 -ErrorAction Stop
    } catch {
        try {
            $null = Get-Command python -ErrorAction Stop
        } catch {
            Write-Color Yellow "WARNING: Python not found. The analyze_blog.py script requires Python 3.11+."
        }
    }

    # Create directories
    Write-Color White "Creating directories..."
    New-Item -ItemType Directory -Force -Path (Join-Path $SkillDir "blog" "references") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $SkillDir "blog" "templates")   | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $SkillDir "blog" "scripts")     | Out-Null
    New-Item -ItemType Directory -Force -Path $AgentDir   | Out-Null
    New-Item -ItemType Directory -Force -Path $CommandDir | Out-Null

    # Copy main skill
    Write-Color White "Installing blog knowledge skill..."
    Copy-Item (Join-Path $ScriptDir "skills" "blog" "SKILL.md") (Join-Path $SkillDir "blog" "SKILL.md") -Force

    # Copy references
    Write-Color White "Installing reference files..."
    Copy-Item (Join-Path $ScriptDir "skills" "blog" "references" "*.md") (Join-Path $SkillDir "blog" "references") -Force

    # Copy templates
    if (Test-Path (Join-Path $ScriptDir "skills" "blog" "templates")) {
        Write-Color White "Installing content templates..."
        Copy-Item (Join-Path $ScriptDir "skills" "blog" "templates" "*.md") (Join-Path $SkillDir "blog" "templates") -Force
    }

    # Copy sub-skills
    Write-Color White "Installing sub-skills..."
    Get-ChildItem -Directory (Join-Path $ScriptDir "skills") | ForEach-Object {
        $skillName = $_.Name
        if ($skillName -eq "blog") { return }
        $skillDst = Join-Path $SkillDir $skillName
        New-Item -ItemType Directory -Force -Path $skillDst | Out-Null

        $src = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $src) {
            Copy-Item $src (Join-Path $skillDst "SKILL.md") -Force
            Write-Color Green "  + $skillName"
        }

        $refSrc = Join-Path $_.FullName "references"
        if (Test-Path $refSrc) {
            $refDst = Join-Path $skillDst "references"
            New-Item -ItemType Directory -Force -Path $refDst | Out-Null
            Get-ChildItem -File $refSrc | ForEach-Object {
                Copy-Item $_.FullName (Join-Path $refDst $_.Name) -Force
            }
        }

        $scriptSrc = Join-Path $_.FullName "scripts"
        if (Test-Path $scriptSrc) {
            $scriptDst = Join-Path $skillDst "scripts"
            New-Item -ItemType Directory -Force -Path $scriptDst | Out-Null
            Get-ChildItem -File $scriptSrc | ForEach-Object {
                Copy-Item $_.FullName (Join-Path $scriptDst $_.Name) -Force
            }
        }

        $assetsSrc = Join-Path $_.FullName "assets"
        if (Test-Path $assetsSrc) {
            $assetsDst = Join-Path $skillDst "assets"
            New-Item -ItemType Directory -Force -Path $assetsDst | Out-Null
            Copy-Item (Join-Path $assetsSrc "*") $assetsDst -Recurse -Force
        }
    }

    # Create personas directory for blog-persona
    New-Item -ItemType Directory -Force -Path (Join-Path $SkillDir "blog" "references" "personas") | Out-Null

    # Copy agents (primary + subagents)
    Write-Color White "Installing agents..."
    Get-ChildItem -File (Join-Path $ScriptDir "agents" "*.md") | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $AgentDir $_.Name) -Force
        Write-Color Green "  + $($_.BaseName)"
    }

    # Copy commands
    if (Test-Path (Join-Path $ScriptDir "commands")) {
        Write-Color White "Installing slash commands..."
        Get-ChildItem -File (Join-Path $ScriptDir "commands" "*.md") | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $CommandDir $_.Name) -Force
            Write-Color Green "  + /$($_.BaseName)"
        }
    }

    # Copy analyzer script
    Write-Color White "Installing analyzer script..."
    Copy-Item (Join-Path $ScriptDir "scripts" "analyze_blog.py") (Join-Path $SkillDir "blog" "scripts" "analyze_blog.py") -Force

    # Install Python dependencies
    Write-Color White "Installing Python dependencies..."
    $reqFile = Join-Path $ScriptDir "requirements.txt"
    if (Test-Path $reqFile) {
        try {
            & python3 -m pip install --quiet -r $reqFile 2>$null
            Write-Color Green "  Python dependencies installed."
        } catch {
            try {
                & python -m pip install --quiet -r $reqFile 2>$null
                Write-Color Green "  Python dependencies installed."
            } catch {
                Write-Color Yellow "  Skipped: install manually with 'pip install -r requirements.txt'"
            }
        }
    }

    # Cleanup temp directory if used
    if ($TempDir -and (Test-Path $TempDir)) {
        Remove-Item -Recurse -Force $TempDir
    }

    # Summary
    Write-Color Cyan @"

   ╔═════════════════════════════════════════╗
   ║       Installation Complete!            ║
   ╚═════════════════════════════════════════╝

"@

    Write-Color White "Installed to $OpenCodeDir:"
    Write-Color Green "  skills/blog/        Knowledge skill (refs + templates + analyzer)"
    Write-Color Green "  skills/blog-*       21 sub-skills"
    Write-Color Green "  agents/blog.md      Primary orchestrator"
    Write-Color Green "  agents/blog-*       4 specialist subagents"
    Write-Color Green "  commands/blog.md    /blog slash command"
    Write-Color White ""
    Write-Color White "Try in OpenCode TUI:"
    Write-Color Cyan  "  /blog write <topic>          Write a new blog post"
    Write-Color Cyan  "  /blog rewrite <file>         Optimize an existing post"
    Write-Color Cyan  "  /blog analyze <file>         Quality audit (0-100)"
    Write-Color Cyan  "  /blog brief <topic>          Content brief"
    Write-Color Cyan  "  /blog calendar               Editorial calendar"
    Write-Color Cyan  "  /blog strategy <niche>       Strategy + topic ideation"
    Write-Color Cyan  "  /blog outline <topic>        SERP-informed outline"
    Write-Color Cyan  "  /blog seo-check <file>       SEO validation"
    Write-Color Cyan  "  /blog schema <file>          JSON-LD schema"
    Write-Color Cyan  "  /blog repurpose <file>       Cross-platform repurposing"
    Write-Color Cyan  "  /blog geo <file>             AI citation readiness audit"
    Write-Color Cyan  "  /blog image <idea>           Gemini image generation"
    Write-Color Cyan  "  /blog audit [directory]      Full-site assessment"
    Write-Color Cyan  "  /blog cannibalization        Detect keyword overlap"
    Write-Color Cyan  "  /blog factcheck              Verify statistics"
    Write-Color Cyan  "  /blog persona                Manage personas"
    Write-Color Cyan  "  /blog taxonomy               CMS taxonomy management"
    Write-Color Cyan  "  /blog notebooklm <q>         NotebookLM research"
    Write-Color Cyan  "  /blog audio <file>           Gemini TTS narration"
    Write-Color Cyan  "  /blog google [cmd]           PSI/CrUX/GSC/GA4/NLP/YouTube/Keywords"
    Write-Color White ""
    Write-Color White "Optional: AI features need a free Google AI API key"
    Write-Color Cyan  "  /blog image setup            Configure Gemini image generation"
    Write-Color Cyan  "  /blog audio setup            Configure Gemini TTS"
    Write-Color White "  Get your key:                https://aistudio.google.com/apikey"
    Write-Color White ""
    Write-Color Yellow "Restart OpenCode (or reload the TUI) to pick up the new skills."
}

Main
