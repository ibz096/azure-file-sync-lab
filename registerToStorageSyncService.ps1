param (
    [string]$ResourceGroupName,
    [string]$StorageSyncServiceName
)
"[$(Get-Date)] Args: ResourceGroup=$ResourceGroupName, SyncService=$StorageSyncServiceName" | Out-File -Append C:\Temp\setup.log
write-host "Registering to Storage Sync Service..." | Out-file -FilePath "C:\temp\registerToStorageSyncService.log" -Append
write-host "Resource Group Name: " | Out-file -FilePath "C:\temp\registerToStorageSyncService.log" -Append
write-host $ResourceGroupName | Out-file -FilePath "C:\temp\registerToStorageSyncService.log" -Append
write-host "Storage Sync Service Name: " | Out-file -FilePath "C:\temp\registerToStorageSyncService.log" -Append
write-host $StorageSyncServiceName | Out-file -FilePath "C:\temp\registerToStorageSyncService.log" -Append

Connect-AzAccount -identity

Register-AzStorageSyncServer -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $StorageSyncServiceName