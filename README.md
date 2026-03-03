# GitHub Pull Request Updater

[![CI — PowerShell Lint](https://github.com/Abderraouf-yt/github-pr-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/Abderraouf-yt/github-pr-updater/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A lightweight, dependency-free PowerShell script that automates the rebasing ("Update Branch") feature of GitHub Pull Requests.

## Why this exists
When you push a major fix to your default branch (like repairing a broken CI/CD pipeline), any active Pull Requests that branched off of an older commit will continue to fail their checks because they are running outdated CI instructions.

Normally, you would have to manually click the **"Update branch"** button in the GitHub UI for every single open PR. If Dependabot just opened 20 PRs, this is incredibly tedious.

This script uses PowerShell's built-in `Invoke-RestMethod` to query the GitHub REST API and forcefully trigger the UI's "Update branch" functionality across dozens of PRs instantly—**without needing the `gh` CLI installed.**

## Usage

You must have a GitHub Personal Access Token (PAT) with at least `repo` permissions to authorize the HTTP requests.

```powershell
.\Rebase-PullRequests.ps1 -Token "ghp_YourPersonalAccessToken" -Owner "YourGitHubUsername" -Repo "YourRepoName"
```

### Targeting Specific Authors
By default, the script only targets PRs opened by `dependabot[bot]`. If you want to bulk-rebase PRs opened by a different user (or by yourself across multiple devices), use the `-Author` parameter:

```powershell
.\Rebase-PullRequests.ps1 -Token "ghp_..." -Owner "Abderraouf-yt" -Repo "got-mcp" -Author "Abderraouf-yt"
```

## How It Works

1. Queries `GET /repos/{owner}/{repo}/pulls?state=open` to fetch all open PRs.
2. Filters the JSON payload for the target author.
3. Loops through the matching PRs and sends a `PUT /repos/{owner}/{repo}/pulls/{number}/update-branch` request.
4. If a PR is already synced to `main`, the GitHub API throws a controlled `422 Unprocessable Entity` response, which the script safely handles and reports as `[ALREADY UP TO DATE]`.

## License

Released under the [MIT License](LICENSE). © 2026 Abderraouf Toumi.

