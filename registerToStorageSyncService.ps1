param (
    [string]$ResourceGroupName,
    [string]$StorageSyncServiceName
)
Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $StorageSyncServiceName