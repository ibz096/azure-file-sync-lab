## Objectives
This is a lab environment to simulate what Azure Files would look like if it were extended on-premise with Azure File Sync and a Windows Server.

We will simulate an on-premise environment by provisioning an Azure Virtual Machine and connecting it to Azure Files using the Storage Sync Service.

This lab attempts to take the steps from: https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-deployment-guide?tabs=azure-portal%2Cproactive-portal and implement them in a bicep template
## Prequisites
* Azure Tenant
## Architecture
## Provisioning
* Create a new resource group with `az group create -g azure-file-sync-lab --location canadacentral`
* Deploy resources: `az deployment group create --template-file main.bicep --parameters param.bicepparam -g azure-file-sync-lab`
## Decommisioning
* You will need to unregister any servers to the Storage Sync Service