# SYSTEM RESOURCE MONITOR - Simple Refresh Version
Clear-Host
Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host "      SYSTEM RESOURCE MONITOR        " -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host "Press Ctrl+C to exit" -ForegroundColor Gray
Write-Host ""

while ($true) {
    Clear-Host
    
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host "      SYSTEM RESOURCE MONITOR        " -ForegroundColor Cyan
    Write-Host ("=" * 50) -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to exit" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Last Update: $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray
    Write-Host ""
    
    $cpu = Get-Counter "\Processor(_Total)\% Processor Time" -ErrorAction SilentlyContinue
    $cpuValue = [math]::Round($cpu.CounterSamples.CookedValue, 1)
    $cpuFilled = [math]::Round($cpuValue / 100 * 30)
    if ($cpuFilled -gt 30) { $cpuFilled = 30 }
    if ($cpuFilled -lt 0) { $cpuFilled = 0 }
    $cpuBar = ("█" * $cpuFilled) + ("░" * (30 - $cpuFilled))
    Write-Host " CPU:  $cpuBar  $cpuValue%" -ForegroundColor Green
    
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedRAM = $totalRAM - $freeRAM
    $ramPercent = [math]::Round(($usedRAM / $totalRAM) * 100, 1)
    $ramFilled = [math]::Round($ramPercent / 100 * 30)
    if ($ramFilled -gt 30) { $ramFilled = 30 }
    if ($ramFilled -lt 0) { $ramFilled = 0 }
    $ramBar = ("█" * $ramFilled) + ("░" * (30 - $ramFilled))
    Write-Host " RAM:  $ramBar  $ramPercent%  ($usedRAM GB / $totalRAM GB)" -ForegroundColor Green
    
    $disk = Get-PSDrive C -ErrorAction SilentlyContinue
    if ($disk) {
        $totalDisk = [math]::Round(($disk.Used + $disk.Free) / 1GB, 2)
        $usedDisk = [math]::Round($disk.Used / 1GB, 2)
        $freeDisk = [math]::Round($disk.Free / 1GB, 2)
        $diskPercent = [math]::Round(($usedDisk / $totalDisk) * 100, 1)
        $diskFilled = [math]::Round($diskPercent / 100 * 30)
        if ($diskFilled -gt 30) { $diskFilled = 30 }
        if ($diskFilled -lt 0) { $diskFilled = 0 }
        $diskBar = ("█" * $diskFilled) + ("░" * (30 - $diskFilled))
        Write-Host " DISK: $diskBar  $diskPercent%  (Free: $freeDisk GB / $totalDisk GB)" -ForegroundColor Green
    } else {
        Write-Host " DISK: Unable to read disk data" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host ("-" * 50) -ForegroundColor Yellow
    Write-Host " TOP 5 PROCESSES (by CPU usage)" -ForegroundColor Yellow
    Write-Host ("-" * 50) -ForegroundColor Yellow
    
    $processes = Get-Process | Where-Object { $_.CPU -gt 0 } | Sort-Object CPU -Descending | Select-Object -First 5
    $counter = 1
    foreach ($proc in $processes) {
        $procName = $proc.ProcessName
        if ($procName.Length -gt 30) {
            $procName = $procName.Substring(0, 27) + "..."
        }
        $cpuSec = [math]::Round($proc.CPU, 1)
        Write-Host " $counter. $($procName.PadRight(30)) - $cpuSec seconds" -ForegroundColor White
        $counter++
    }
    
    Write-Host ""
    Write-Host ("-" * 50) -ForegroundColor Gray
    Write-Host " Press Ctrl+C to exit" -ForegroundColor Gray
    
    Start-Sleep -Seconds 2
}
