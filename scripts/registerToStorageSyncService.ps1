param (
    [string]$ResourceGroupName,
    [string]$StorageSyncServiceName
)
"[$(Get-Date)] Args: ResourceGroup=$ResourceGroupName, SyncService=$StorageSyncServiceName" | Out-File -Append C:\Temp\setup.log

Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $StorageSyncServiceName