param storageAccountName string
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
    name: 'myVnet'
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.0.0.0/16'
            ]
        }
    }
}
resource defaultSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' ={
    parent: vnet
    name: 'default'
    properties: {
        // The address prefix for the subnet
        // This should be a subset of the address space defined in the virtual network
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroup: {
            id: nsg.id
        }
    }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
    name: 'myNsg'
    location: location
    properties: {
        securityRules: [
            {
                name: 'allow-rdp'
                properties: {
                    protocol: 'Tcp'
                    sourcePortRange: '*'
                    destinationPortRange: '3389'
                    sourceAddressPrefix: '*'
                    destinationAddressPrefix: '*'
                    access: 'Allow'
                    priority: 1000
                    direction: 'Inbound'
                }
            }
        ]
    }
}

//storage account

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

// file service
resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
  // properties: {
  //   shareDefaultAccessTier: 'Hot'
  // }
}

// file share
resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  name: 'myfileshare'
  parent: fileService
  properties: {
    shareQuota: 100
  }
}

//storage sync service
resource storageSyncService 'Microsoft.StorageSync/storageSyncServices@2022-09-01' = {
  name: 'syncservice'
  location: location
}

module vm 'modules/vm.bicep' = {
    name: 'myVm'
    params: {
        vmName: 'myVm'
        location: location
        subnetId: defaultSubnet.id
        adminUserName: 'adminUser'
        adminPassword: 'P@ssw0rd1234!'
        vmSize: 'Standard_B2ms'
    }
}

resource customSyncRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id, 'Custom.StorageSync.RegistrationRole')
  scope: resourceGroup()
  properties: {
    roleName: 'Custom Storage Sync Registration Role'
    description: 'Allows limited access to register servers with Storage Sync Services'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.StorageSync/storageSyncServices/registeredServers/write'
          'Microsoft.StorageSync/storageSyncServices/registeredServers/read'
          'Microsoft.StorageSync/storageSyncServices/read'
          'Microsoft.StorageSync/storageSyncServices/workflows/read'
          'Microsoft.StorageSync/storageSyncServices/workflows/operations/read'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

resource syncRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageSyncService.id, vm.name, 'storage-sync-role')
  scope: storageSyncService
  properties: {
    roleDefinitionId: customSyncRole.id
    principalId: vm.outputs.vmPrincipalId
  }
}

module scriptExtension 'modules/scriptExtension.bicep' = {
  name: 'scriptDeploymnt'
  dependsOn: [
    syncRoleAssignment
  ]
  params: {
    vmName: vm.name
    location: location
    storageSyncServiceName: storageSyncService.name
    resourceGroupName: resourceGroup().name
  }
}
