# setup.ps1
param (
    [string]$ResourceGroupName,
    [string]$StorageSyncServiceName
)
# Install the Azure PowerShell module and the Azure File Sync agent
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Microsoft.PowerShell.PSResourceGet -Repository PSGallery -Force -Scope AllUsers
Set-PSResourceRepository -Name PSGallery -Trusted
Install-PSResource -Name Az.Accounts, Az.StorageSync -AcceptLicense -Scope AllUsers

.\disableIESecurity.ps1
.\installAzureFileSyncAgent.ps1
.\registerToStorageSyncService.ps1 -ResourceGroupName $ResourceGroupName -StorageSyncServiceName $StorageSyncServiceName