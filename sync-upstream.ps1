# sync-upstream.ps1
# Pulls the latest changes from upstream/main into your main branch,
# then pushes the result to your fork (origin).

$ErrorActionPreference = "Stop"

# Make sure we're on main
$branch = git rev-parse --abbrev-ref HEAD
if ($branch -ne "main") {
    Write-Host "You're on '$branch', not 'main'. Switch with: git switch main" -ForegroundColor Yellow
    exit 1
}

# Refuse to run with uncommitted changes
if (git status --porcelain) {
    Write-Host "You have uncommitted changes. Commit or stash them first." -ForegroundColor Yellow
    exit 1
}

Write-Host "Fetching upstream..." -ForegroundColor Cyan
git fetch upstream
if ($LASTEXITCODE -ne 0) { Write-Host "Fetch failed." -ForegroundColor Red; exit 1 }

Write-Host "Merging upstream/main into main..." -ForegroundColor Cyan
git merge upstream/main
if ($LASTEXITCODE -ne 0) {
    Write-Host "Merge stopped (probably conflicts). Fix the files, then run:" -ForegroundColor Red
    Write-Host "  git add <files>; git commit; git push"
    exit 1
}

Write-Host "Pushing to your fork..." -ForegroundColor Cyan
git push
if ($LASTEXITCODE -ne 0) { Write-Host "Push failed." -ForegroundColor Red; exit 1 }

Write-Host "Done. Your main is up to date with upstream." -ForegroundColor Green
