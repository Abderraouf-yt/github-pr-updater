# Contributing to GitHub PR Updater

Thank you for your interest in contributing! This is a lightweight PowerShell utility, so contributions are very welcome.

## Getting Started

1. **Fork** this repository
2. **Clone** your fork locally
3. Create a descriptive branch: `git checkout -b feat/your-feature`
4. Make your changes to `Rebase-PullRequests.ps1`
5. **Test** your changes manually against a real or test repo
6. **Lint** your code with PSScriptAnalyzer:
   ```powershell
   Install-Module PSScriptAnalyzer -Force -Scope CurrentUser
   Invoke-ScriptAnalyzer -Path .\Rebase-PullRequests.ps1
   ```
7. Commit with a descriptive message and open a Pull Request

## Code Standards

- Follow standard PowerShell conventions (Verb-Noun naming, comment-based help)
- Keep the script dependency-free (no external modules — `Invoke-RestMethod` only)
- All parameters must have `[Parameter(...)]` attributes
- Preserve the existing error handling pattern for API responses

## Reporting Bugs

Please open an issue using the Bug Report template. Include your PowerShell version and the exact error message.

## Security Issues

**Do not open public issues for security vulnerabilities.** See [SECURITY.md](SECURITY.md).
