<#
.SYNOPSIS
    Automates the "Update Branch" (Rebase) functionality for GitHub Pull Requests.

.DESCRIPTION
    This script queries the GitHub REST API for open Pull Requests from a specific author 
    (like Dependabot) and forces the GitHub backend to rebase them against the latest `main` commit.
    This resolves CI/CD failures caused by PRs branching off an outdated main branch.

.PARAMETER Token
    Your GitHub Personal Access Token (PAT) with `repo` permissions.

.PARAMETER Owner
    The GitHub user or organization that owns the repository (e.g., "Abderraouf-yt").

.PARAMETER Repo
    The name of the repository (e.g., "got-mcp").

.PARAMETER Author
    The username of the PR author to target. Defaults to 'dependabot[bot]'.

.EXAMPLE
    .\Rebase-PullRequests.ps1 -Token "ghp_yourtoken..." -Owner "Abderraouf-yt" -Repo "got-mcp"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Token,

    [Parameter(Mandatory=$true)]
    [string]$Owner,

    [Parameter(Mandatory=$true)]
    [string]$Repo,

    [Parameter(Mandatory=$false)]
    [string]$Author = "dependabot[bot]"
)

$headers = @{
    "Authorization" = "Bearer $Token"
    "Accept"        = "application/vnd.github.v3+json"
}

Write-Host "Querying open Pull Requests for $Owner/$Repo..." -ForegroundColor Cyan

$prsUrl = "https://api.github.com/repos/$Owner/$Repo/pulls?state=open&per_page=100"
$allPrs = Invoke-RestMethod -Uri $prsUrl -Headers $headers -ErrorAction Stop

$targetPrs = $allPrs | Where-Object { $_.user.login -eq $Author }

if ($targetPrs.Count -eq 0) {
    Write-Host "No open Pull Requests found by author: $Author" -ForegroundColor Green
    return
}

Write-Host "Found $($targetPrs.Count) open PRs from $Author. Initiating bulk rebase..." -ForegroundColor Cyan

foreach ($pr in $targetPrs) {
    Write-Host "Updating PR #$($pr.number) - $($pr.title)" -NoNewline
    
    $updateUrl = "https://api.github.com/repos/$Owner/$Repo/pulls/$($pr.number)/update-branch"
    
    try {
        Invoke-RestMethod -Uri $updateUrl -Method Put -Headers $headers -ContentType "application/json" | Out-Null
        Write-Host "  ---> [SUCCESS]" -ForegroundColor Green
    } catch {
        # 422 Unprocessable Entity usually means it's already up to date
        if ($_.Exception.Response.StatusCode.value__ -eq 422) {
            Write-Host "  ---> [ALREADY UP TO DATE]" -ForegroundColor Yellow
        } else {
            Write-Host "  ---> [FAILED: $($_.Exception.Message)]" -ForegroundColor Red
        }
    }
}

Write-Host "`nBulk rebase complete!" -ForegroundColor Cyan
