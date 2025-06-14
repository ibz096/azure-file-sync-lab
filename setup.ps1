# setup.ps1
param (
    [string]$ResourceGroupName,
    [string]$StorageSyncServiceName
)
# Install the Azure PowerShell module and the Azure File Sync agent
Install-Module -Name Microsoft.PowerShell.PSResourceGet -Repository PSGallery -Force -Scope AllUsers
Set-PSResourceRepository -Name PSGallery -Trusted
Install-PSResource -Name Az.Accounts, Az.StorageSync -AcceptLicense -Scope AllUsers

.\disableIESecurity.ps1
.\installAzureFileSyncAgent.ps1
.\registerToStorageSyncService -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $StorageSyncServiceName