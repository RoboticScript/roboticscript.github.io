# PowerShell Notes

## Get Running Services

```powershell
Get-Service | Where-Object {$_.Status -eq 'Running'}
