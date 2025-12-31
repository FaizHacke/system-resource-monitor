# Activity Generator with Custom Pattern: 5,10,3,8,6,1,2 repeating
# From January 1, 2023 to December 31, 2025

param(
    [bool]$DryRun = $false
)

# Define the repeating pattern (7-day cycle)
$pattern = @(5, 10, 3, 8, 6, 1, 2)

$startDate = "2023-01-01"
$endDate = "2025-12-31"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "     ACTIVITY GENERATOR (2023 - 2025)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Start Date: $startDate" -ForegroundColor Yellow
Write-Host "End Date: $endDate" -ForegroundColor Yellow
Write-Host "Pattern: $pattern" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "DRY RUN MODE - No commits will be made" -ForegroundColor Yellow
    Write-Host ""
}

$currentDate = [DateTime]$startDate
$endDateObj = [DateTime]$endDate
$totalCommits = 0
$daysProcessed = 0
$dayInCycle = 0

# Calculate total days for progress
$totalDays = ($endDateObj - $currentDate).Days + 1

while ($currentDate -le $endDateObj) {
    # Get commits for today based on pattern
    $commitsToday = $pattern[$dayInCycle]
    $dateStr = $currentDate.ToString("yyyy-MM-dd")
    
    for ($c = 1; $c -le $commitsToday; $c++) {
        $randomHour = Get-Random -Min 9 -Max 17
        $randomMinute = Get-Random -Min 0 -Max 59
        $timestamp = "$dateStr $randomHour`:$randomMinute`:00"
        
        if (-not $DryRun) {
            $logEntry = "$dateStr - Commit $c of $commitsToday (Pattern day $($dayInCycle + 1))"
            Add-Content -Path "activity-pattern.log" -Value $logEntry
            git add activity-pattern.log
            $env:GIT_AUTHOR_DATE = $timestamp
            $env:GIT_COMMITTER_DATE = $timestamp
            git commit -m "$logEntry"
        }
        $totalCommits++
    }
    
    $daysProcessed++
    $dayInCycle++
    
    # Reset pattern cycle every 7 days
    if ($dayInCycle -ge 7) {
        $dayInCycle = 0
    }
    
    # Show progress every 30 days
    if ($daysProcessed % 30 -eq 0) {
        $percentComplete = [math]::Round(($daysProcessed / $totalDays) * 100, 1)
        Write-Host "Progress: $daysProcessed / $totalDays days ($percentComplete%) - Current date: $dateStr" -ForegroundColor Gray
    }
    
    $currentDate = $currentDate.AddDays(1)
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "COMPLETE!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Total days processed: $daysProcessed" -ForegroundColor Yellow
Write-Host "Total commits created: $totalCommits" -ForegroundColor Yellow
Write-Host "Average commits per day: $([math]::Round($totalCommits / $daysProcessed, 1))" -ForegroundColor Yellow
Write-Host "Date range: $startDate to $endDate" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan

if (-not $DryRun) {
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    git push origin main
    Write-Host "Done!" -ForegroundColor Green
    Write-Host ""
    Write-Host "View your graph: https://github.com/FaizHacke/system-resource-monitor" -ForegroundColor Cyan
}