param (
    [string]$ResourceGroupName,
    [string]$StorageSyncServiceName
)

write-host $ResourceGroupName
write-host $StorageSyncServiceName

Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $StorageSyncServiceName