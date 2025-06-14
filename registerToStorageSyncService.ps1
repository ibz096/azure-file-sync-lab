param (
    [string]$ResourceGroupName,
    [string]$SyncServiceName
)

Install-Module -Name Microsoft.PowerShell.PSResourceGet -Repository PSGallery -Force -Scope AllUsers
Set-PSResourceRepository -Name PSGallery -Trusted
Install-PSResource -Name Az.Accounts, Az.StorageSync -AcceptLicense -Scope AllUsers

Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupNameync -StorageSyncServiceName $SyncServiceName