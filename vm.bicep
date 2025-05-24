param vmName string
param location string
param subnetId string
param adminUserName string
@secure()
param adminPassword string
param vmSize string = 'Standard_B2ms'

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: '${vmName}-public-ip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    // dnsSettings: {
    //   domainNameLabel: 'dnsname'
    // }
  }
}
resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource scriptExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: 'script-extension'
  location: location
  parent: vm
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
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File setup.ps1'
    }
  }
}
