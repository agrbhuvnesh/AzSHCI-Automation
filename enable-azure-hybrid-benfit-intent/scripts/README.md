# AzSHCI-Automation

Manage Azure Hybrid Benefit settings for Azure Stack HCI clusters using PowerShell and Azure CLI.

## Prerequisites

Before running the scripts, ensure you have the following parameters ready:

- `$subscription`: Azure subscription ID.
- `$resourceGroup`: Name of the Azure resource group.
- `$tenant`: Azure AD tenant ID.

## Enabling and Disabling Azure Hybrid Benefit

The provided scripts allow you to enable and disable Azure Hybrid Benefit for Azure Stack HCI clusters using both PowerShell and Azure CLI.

### Script 1: Enabling Azure Hybrid Benefit

#### PowerShell

1. Log in to your Azure account using `Connect-AzAccount` and specify the tenant using `-Tenant`.
2. Set the context to the desired subscription.
3. Run the script. It will enable Azure Hybrid Benefit for all clusters in the specified resource group.

#### Azure CLI

1. Log in to your Azure account using `az login` and specify the tenant using `az account set`.
2. Run the script. It will enable Azure Hybrid Benefit for all clusters in the specified resource group.

### Script 2: Disabling Azure Hybrid Benefit

#### PowerShell

1. Log in to your Azure account using `Connect-AzAccount` and set the context to the desired subscription.
2. Run the script. It will disable Azure Hybrid Benefit for all clusters in the specified resource group.

#### Azure CLI

1. Log in to your Azure account using `az login` and specify the tenant using `az account set`.
2. Run the script. It will disable Azure Hybrid Benefit for all clusters in the specified resource group.

