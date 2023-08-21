# AzSHCI-Automation

Manage Diagnostic Level and Windows Server Subscription settings for Azure Stack HCI clusters using PowerShell and Azure CLI.

## Prerequisites

Before running the scripts, ensure you have the following parameters ready:

- `$subscriptionId`: Azure subscription ID.
- `$resourceGroup`: Name of the Azure resource group.
- `$tenantId`: Azure AD tenant ID.

## Disabling Diagnostic Level and Windows Server Subscription

### Script: Disabling

#### Using PowerShell

1. Log in to your Azure account using `Connect-AzAccount` and set the context to the desired subscription.
2. Run the script. It will disable diagnostic level and Windows Server Subscription for all clusters in the specified resource group.

#### Using Azure CLI

1. Log in to your Azure account using `az login` and specify the tenant using `az account set`.
2. Run the script. It will disable diagnostic level and Windows Server Subscription for all clusters in the specified resource group.

## Enabling Diagnostic Level and Windows Server Subscription

### Script: Enabling

#### Using PowerShell

1. Log in to your Azure account using `Connect-AzAccount` and set the context to the desired subscription.
2. Run the script. It will enable diagnostic level and Windows Server Subscription for all clusters in the specified resource group.

#### Using Azure CLI

1. Log in to your Azure account using `az login` and specify the tenant using `az account set`.
2. Run the script. It will enable diagnostic level and Windows Server Subscription for all clusters in the specified resource group.



