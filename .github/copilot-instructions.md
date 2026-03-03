# GitHub Copilot Instructions — github-pr-updater

## Project Context

This is a **dependency-free PowerShell script** that automates the GitHub "Update Branch" (rebase) action across multiple Pull Requests via the GitHub REST API. It accepts parameters at runtime — no configuration files, no modules, no package manager.

## Security Rules

- **NEVER hardcode tokens, API keys, or credentials** — all secrets must be passed as parameters (`-Token`)
- **NEVER log or print the token value** — never echo `$Token` to console
- All API calls use `Invoke-RestMethod` with `Bearer` authentication headers
- Handle `422 Unprocessable Entity` responses gracefully (already up to date)

## Code Style

- Use PowerShell **Verb-Noun** naming conventions (e.g., `Get-PullRequests`, `Update-Branch`)
- All parameters must have `[Parameter(Mandatory=$true/false)]` attributes and `[string]` type annotations
- Use comment-based help blocks (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`)
- Use `Write-Host` with `-ForegroundColor` for user-facing output (Cyan = info, Green = success, Yellow = warning, Red = error)
- Keep the script **runnable without any module installation**

## Architecture

- Single-file script: `Rebase-PullRequests.ps1`
- No external dependencies — `Invoke-RestMethod` only
- Error handling via `try/catch` inspecting `$_.Exception.Response.StatusCode.value__`
