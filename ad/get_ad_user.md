# GET AD USER
```powershell
# GET AD USER
Get-ADUser -Filter * -Properties Title | Format-Table Name, SamAccountName, Title
```
