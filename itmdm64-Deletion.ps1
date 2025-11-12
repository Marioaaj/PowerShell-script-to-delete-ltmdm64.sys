
# --- Script to forcefully delete a file with elevated permissions ---




# --- Step 2: Get and Display System Information ---
$computerName = $env:COMPUTERNAME
$windowsVersion = (Get-ComputerInfo).WindowsProductName
$windowsDisplayVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
$lastUpdateDate = (Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 1).InstalledOn

Write-Host "--- Vulnerability Remediation Script ---" -ForegroundColor Cyan
Write-Host "Computer Name:   $computerName"






# 1. CHECK FOR ADMINISTRATIVE PRIVILEGES AND RE-LAUNCH IF NECESSARY
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # If not running as admin, re-launch the script with elevated rights
    Write-Warning "This script requires administrator privileges. Attempting to relaunch as an administrator..."
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 2. DEFINE THE TARGET FILE PATH
$filePath = "C:\Windows\System32\DriverStore\FileRepository\mdmagm64.inf_amd64_596c8fd6d9bb0499\ltmdm64.sys"
Write-Host "Target file: $filePath" -ForegroundColor Cyan

# 3. PRE-DELETION CHECK
Write-Host "Performing pre-deletion check..."
if (Test-Path $filePath) {
    # This is the first requested check
    Write-Host "[FOUND] The file exists. Proceeding with deletion attempt." -ForegroundColor Yellow
}
else {
    Write-Host "[NOT FOUND] The file does not exist. No action needed." -ForegroundColor Green
    exit
}

# 4. ATTEMPT TO DELETE THE FILE
Write-Host "Attempting to delete the file...Performing post-deletion verification..."

try {
    # Step 1: Take ownership of the file.
    # The '/F' flag specifies the file.
    takeown.exe /F $filePath | Out-Null

    # Step 2: Grant the 'Administrators' group full control.
    # The '/grant' flag gives permissions. 'administrators:F' means full control for the Administrators group.
    icacls.exe $filePath /grant administrators:F | Out-Null

    # Step 3: Delete the file.
    # The '-Force' parameter attempts to remove read-only or hidden files.
    Remove-Item -Path $filePath -Force -ErrorAction Stop
    
}
catch {
    # If any part of the process fails, this block will run.
    Write-Host "[ERROR] Failed to delete the file." -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
}

# 5. POST-DELETION VERIFICATION
# This is the second requested check
if (-not (Test-Path $filePath)) {
    Write-Host "[VERIFIED] The file has been confirmed to be deleted." -ForegroundColor Green
}
else {
    Write-Host "[VERIFICATION FAILED] The file still exists. The deletion was unsuccessful." -ForegroundColor Red
}

Write-Host "-------------------------------------------------`n"
