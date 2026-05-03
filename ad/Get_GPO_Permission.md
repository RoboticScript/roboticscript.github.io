# GET GPO PERMISSION

## AD

```powershell
# IMPORT THE ACTIVE DIRECTORY MODULE
Import-Module ActiveDirectory

# RETRIEVE ALL GPOS IN THE DOMAIN
$AllGPOs = Get-GPO -All -ErrorAction Stop

# INITIALIZE AN ARRAY TO STORE THE RESULTS
$Results = @()

# LOOP THROUGH EACH GPO AND GET PERMISSIONS
foreach ($GPO in $AllGPOs) {
    try {
        $Permissions = Get-GPPermissions -Guid $GPO.Id -All
        foreach ($Permission in $Permissions) {
            $TrusteeName = $Permission.Trustee.Name             # EXTRACT READABLE NAME
            #$TrusteeSID = $Permission.Trustee.SID              # EXTRACT SID IF NEEDED
            $TrusteeType = $Permission.Trustee.SidType # EXTRACT TRUSTEE TYPE

            $Results += [PSCustomObject]@{
                GPOName     = $GPO.DisplayName
                Trustee     = $TrusteeName
                #TrusteeSID  = $TrusteeSID
                TrusteeType   = $TrusteeType
                Permission  = $Permission.Permission
                Inherited   = $Permission.Inherited
            }
        }
    } catch {
        Write-Warning "Failed to get permissions for GPO: $($GPO.DisplayName)"
    }
}

# DISPLAY THE RESULTS IN A TABLE
$Results | Format-Table GPOName, Trustee, TrusteeType, Permission, Inherited -AutoSize

# EXPORT RESULTS TO A CSV FILE (OPTIONAL)
$Results | Export-Csv -Path "GPO_Permissions.csv" -NoTypeInformation


```
