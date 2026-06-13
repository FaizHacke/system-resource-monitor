# Activity Generator for system-resource-monitor
# Run this script to generate activity in this repository

param(
    [int]$Days = 30,
    [int]$CommitsPerDay = 2,
    [bool]$DryRun = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   ACTIVITY GENERATOR" -ForegroundColor Cyan
Write-Host "   For: system-resource-monitor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Days: $Days" -ForegroundColor Yellow
Write-Host "Commits per day: $CommitsPerDay" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "DRY RUN MODE - No commits will be made" -ForegroundColor Yellow
    Write-Host ""
}

$startDate = (Get-Date).AddDays(-$Days)
$totalCommits = 0

for ($i = 0; $i -le $Days; $i++) {
    $currentDate = $startDate.AddDays($i)
    $dateStr = $currentDate.ToString("yyyy-MM-dd")
    
    for ($c = 1; $c -le $CommitsPerDay; $c++) {
        $randomHour = Get-Random -Min 0 -Max 23
        $randomMinute = Get-Random -Min 0 -Max 59
        $timestamp = "$dateStr $randomHour`:$randomMinute`:00"
        
        if (-not $DryRun) {
            # Append to activity log file
            Add-Content -Path "activity.log" -Value "Activity on $dateStr at $randomHour`:$randomMinute"
            git add activity.log
            $env:GIT_AUTHOR_DATE = $timestamp
            $env:GIT_COMMITTER_DATE = $timestamp
            git commit -m "Activity update for $dateStr"
        }
        $totalCommits++
    }
    Write-Host "Processed: $dateStr - $CommitsPerDay commits" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total commits created: $totalCommits" -ForegroundColor Green

if (-not $DryRun) {
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    git push origin main
    Write-Host "Done!" -ForegroundColor Green
}