# 1. Define the destination OU
# This would be for example.local
$TargetOU = "OU=SampleOU,DC=Example,DC=local"

# 2. Paste your list of usernames between the @" and "@ below.
# Just keep them one per line, exactly as you have them.
$RawUsers = @"
Sample
Sample2
"@

# 3. Clean up the list (splits by line and removes any accidental blank lines)
$UserList = $RawUsers -split '\r?\n' | Where-Object { $_ -match '\S' }

# 4. Run the loop to move the users
foreach ($User in $UserList) {
    # Trim any accidental whitespace around the username
    $User = $User.Trim()
    
    try {
        Get-ADUser -Identity $User | Move-ADObject -TargetPath $TargetOU
        Write-Host "Successfully moved: $User" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to move $User. Error: $_"
    }
}