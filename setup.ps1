# setup.ps1
param (
    [string]$ResourceGroupName,
    [string]$SyncServiceName
)

.\disableIESecurity.ps1
.\installAzureFileSyncAgent.ps1
.\registerToStorageSyncService -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $SyncServiceName