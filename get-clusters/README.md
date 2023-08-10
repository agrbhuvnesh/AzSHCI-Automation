# AzSHCI-Automation

Retrieve Azure Stack HCI clusters based on various criteria using PowerShell and Azure CLI.

## Prerequisites

Before running the scripts, ensure you have the following parameters ready:

- `$subscriptionId`: Azure subscription ID.
- `$resourceGroup`: Name of the Azure resource group.
- `$tenantId`: Azure AD tenant ID.

## Getting Clusters with IMDS Attestation Enabled

### Script: Get Clusters with IMDS Attestation Enabled

#### Using PowerShell

1. Log in to your Azure account using `Connect-AzAccount` and set the context to the desired subscription.
2. Run the script. It will retrieve clusters with IMDS attestation enabled in the specified resource group.

#### Using Azure CLI

1. Log in to your Azure account using `az login` and specify the tenant using `az account set`.
2. Run the script. It will retrieve clusters with IMDS attestation enabled in the specified resource group.

## Getting Clusters by Location

### Script: Get Clusters by Location

#### Using PowerShell

1. Log in to your Azure account using `Connect-AzAccount` and set the context to the desired subscription.
2. Run the script. It will retrieve clusters located in the specified location (e.g., EastUS) within the resource group.

#### Using Azure CLI

1. Log in to your Azure account using `az login` and specify the tenant using `az account set`.
2. Run the script. It will retrieve clusters located in the specified location (e.g., EastUS) within the resource group.

## Getting Clusters with Software Assurance Enabled

### Script: Get Clusters with Software Assurance Enabled

#### Using PowerShell

1. Log in to your Azure account using `Connect-AzAccount` and set the context to the desired subscription.
2. Run the script. It will retrieve clusters with software assurance enabled in the specified resource group.

#### Using Azure CLI

1. Log in to your Azure account using `az login` and specify the tenant using `az account set`.
2. Run the script. It will retrieve clusters with software assurance enabled in the specified resource group.


