# Import the Active Directory module
Import-Module ActiveDirectory

# Define the list of target groups you want to check for. 
$targetGroups = @("sample", "sample2")

# Define where you want the file saved
$exportPath = "C:\Temp\FilteredUsers.csv"

# Ensure the C:\Temp directory exists so the script doesn't error out
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Force -Path "C:\Temp" | Out-Null
}

# ==============================================================================
# STEP 1: Get a list of all enabled users and store them in a variable
# ==============================================================================
Write-Host "Fetching enabled users..."
$enabledUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties MemberOf

# ==============================================================================
# STEP 2: Filter that list to check for group membership (OR Statement logic)
# ==============================================================================
Write-Host "Filtering users by group membership..."
$finalList = foreach ($user in $enabledUsers) {
    
    $hasMatchedGroup = $false
    $allUserGroups = @() # <--- Added: Creates an empty array for this user

    if ($user.MemberOf) {
        foreach ($groupDN in $user.MemberOf) {
            
            $groupName = ($groupDN -split ",")[0] -replace "^CN=",""
            
            $allUserGroups += $groupName # <--- Added: Saves the group name to the array

            if ($targetGroups -contains $groupName) {
                $hasMatchedGroup = $true
                # The 'break' command is removed so it keeps gathering all groups
            }
        }
    }

    if ($hasMatchedGroup) {
        
        # <--- Added: Joins the array into a single string for the CSV
        $groupsString = $allUserGroups -join "; " 

        # Create a clean object so the CSV columns are perfectly formatted
        [PSCustomObject]@{
            Name              = $user.Name
            SamAccountName    = $user.SamAccountName
            UserPrincipalName = $user.UserPrincipalName
            AllGroups         = $groupsString 
        }
    }
}

# ==============================================================================
# STEP 3: Export to CSV
# ==============================================================================
if ($finalList) {
    Write-Host "Found $($finalList.Count) matching users." -ForegroundColor Green
    Write-Host "Exporting to $exportPath..."
    
    # Export the final list to CSV without the messy type information header
    $finalList | Export-Csv -Path $exportPath -NoTypeInformation -Encoding UTF8
    
    Write-Host "Export complete!" -ForegroundColor Green
} else {
    Write-Host "No users found matching those groups. No CSV created." -ForegroundColor Yellow
}