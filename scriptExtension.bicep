param vmName string
param location string
param storageSyncServiceName string
param resourceGroupName string = resourceGroup().name

resource scriptExtension 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  name: '${vmName}/setup-script'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/ibz096/azure-file-sync-lab/refs/heads/master/disableIESecurity.ps1'
        'https://raw.githubusercontent.com/ibz096/azure-file-sync-lab/refs/heads/master/installAzureFileSyncAgent.ps1'
        'https://raw.githubusercontent.com/ibz096/azure-file-sync-lab/refs/heads/master/setup.ps1'
        'https://raw.githubusercontent.com/ibz096/azure-file-sync-lab/refs/heads/master/registerToStorageSyncService.ps1'
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File setup.ps1 -storageSyncServiceName ${storageSyncServiceName} -resourceGroupName ${resourceGroupName}'
    }
  }
}
