param (
    [string]$ResourceGroupName,
    [string]$SyncServiceName
)
Install-Module -Name Az -Force

Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupNameync -StorageSyncServiceName $SyncServiceName