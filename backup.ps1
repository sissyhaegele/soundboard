# Soundboard Backup Script
param(
    [string]$Message = "Backup"
)

$date = Get-Date -Format "yyyy-MM-dd_HHmm"
$branch = "backup/$date"

Write-Host "Creating backup branch: $branch" -ForegroundColor Yellow

# Create backup branch
git checkout -b $branch
git add .
git commit -m "Backup: $Message - $date"
git push origin $branch

# Return to main
git checkout main

Write-Host "Backup created successfully!" -ForegroundColor Green
Write-Host "Branch: $branch" -ForegroundColor Cyan