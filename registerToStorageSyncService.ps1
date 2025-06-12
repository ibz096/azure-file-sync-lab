param (
    [string]$ResourceGroupName,
    [string]$SyncServiceName
)
Install-Module -Name Az.Accounts -Force -Scope AllUsers
Install-Module -Name Az.StorageSync -Force -Scope AllUsers

Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupNameync -StorageSyncServiceName $SyncServiceName