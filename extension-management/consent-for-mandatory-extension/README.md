## The given script consents and installs the default extensions (azure managed) using Invoke-AzRestMethod, Az StackHCI Powershell Module and Az CLI 

### Pre-Requisites: 

1. [Az.StackHCI Module](https://www.powershellgallery.com/packages/Az.StackHCI/2.1.0) version >= 2.1.0 

Check if module is already installed: Get-InstalledModule Az.StackHCI   
To update-module: Update-Module Az.StackHCI  
To install module: Install-Module -Name Az.StackHCI -RequiredVersion 2.1.0  

2. [az-cli](https://learn.microsoft.com/en-us/cli/azure/stack-hci?view=azure-cli-latest) version = "2.51.0", az cli stack-hci version = 0.1.8 

To check az cli version, run: az version  
To add stack-hci extension, run: az extension add --name stack-hci   
To update, run: az upgrade  