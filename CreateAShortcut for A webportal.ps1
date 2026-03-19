# 1. Define the destination and the content you provided
$Destination = "C:\Users\Public\Desktop\VideaAI.url"
$ShortcutBody = @"
[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,11
[InternetShortcut]
IDList=
URL=https://app.videa.ai/
IconIndex=0
HotKey=0
IconFile=C:\Users\Administrator\Downloads\VideaAssistReadyIcon.ico
"@

Write-Host "--- Initializing Shortcut Setup ---" -ForegroundColor Yellow

try {
    # 2. Write the content to the Public Desktop
    # We use ASCII encoding here as it is standard for .url files
    $ShortcutBody | Out-File -FilePath $Destination -Encoding ascii -ErrorAction Stop

    # 3. Verify the file was actually created
    if (Test-Path $Destination) {
        Write-Host "[SUCCESS]: VideaAI.url is now on the Public Desktop." -ForegroundColor Green
        
        # 4. Confirm the link is present inside the file as requested
        $FileCheck = Get-Content $Destination | Select-String "URL="
        if ($FileCheck) {
            Write-Host "[CONFIRMED]: The internal link exists: $($FileCheck.Line)" -ForegroundColor Cyan
        } else {
            Write-Host "[ERROR]: File created, but the URL line is missing." -ForegroundColor Red
        }
    }
}
catch {
    Write-Host "[CRITICAL]: Access Denied. Please right-click PowerShell and 'Run as Administrator'." -ForegroundColor Red
    Write-Host "Technical Detail: $($_.Exception.Message)"
}

Write-Host "--- Process Finished ---" -ForegroundColor Yellow