param (
    [string]$ResourceGroupName,
    [string]$SyncServiceName
)

Install-Module -Name Microsoft.PowerShell.PSResourceGet -Repository PSGallery
Install-PSResource -Name Az.Accounts, Az.StorageSync -Force -Scope AllUsers

Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupNameync -StorageSyncServiceName $SyncServiceName