# Azure Policies for HCI Cluster Monitoring

## Overview

This repository includes terraform code for the 3 Azure Polices repair-clusters, ama, dcra, and their assignments


## Azure pipelines

### Create Policy and Assignments pipeline

The  creates the [Create Policies and Assignments Pipeline](./azure-pipeline.yaml) creates the resources detailed in the [Resources managed by the terraform pipelines](#resources-managed-by-the-terraform-pipelines) section

### Cleanup/Destroy Policy and Assignments pipeline

The [Cleanup/Destroy Policy and Assignments Pipeline](./azure-pipeline-destroy.yaml) destroys the resources detailed in the [Resources managed by the terraform pipelines](#resources-managed-by-the-terraform-pipelines) section

## Resources managed by the terraform pipelines

* [Data Collection Rule](./terraform/data-collection-rule.tf): The Data Collection Rule is created in the specified resource group (var data_collection_rule_rg), and associated with the configured log analytics workspace (var log_analytics_workspace_rg and log_analytics_workspace_name). The data collection rule is set up with all performance counter and event log names, which are required for HCI cluster monitoring
* Policy Definitions
  * [repair-clusters](./terraform/repair-clusters-ama-policy-definition.tf)
  * [ama](./terraform/ama-policy-definition.tf)
  * [dcra](./terraform/dcra-policy-definition.tf)
* Policy Assignment: Policy assignments at both subscription and resource group levels are created for the above policy definitions. Depending on the requirement we can either remove subscription level or resource group level policy assignments. For resource group level policy assignments comma seperated list of resource group names can be specified in the variable policy_assignment_rg_names. The policy assignments are associated with a managed identity (var user_assigned_identity_name and user_assigned_identity_rg),This managed identity needs to be provided required permissions for the policy to work as expected. If needed 3 different managed identities may be associated with the different policy assignments. The policy assignments are created in the location specified in the variable policy_assignment_location.
  * [repair-clusters](./terraform/repair-clusters-ama-policy-assignment.tf)
  * [ama](./terraform/ama-policy-assignment.tf)
  * [dcra](./terraform/dcra-policy-assignment.tf)

## Terraform Key Variables

The values for the below variables need to be provided in the [variable values file](./terraform/dev.auto.tfvars)

* log_analytics_workspace_name : The log analytics workspace to be associated with the created data collection rule
* log_analytics_workspace_rg: The resource group name where the log analytics workspace exists
* data_collection_rule_rg: The resource group name where the data collection rule is to be created
* policy_assignment_rg_names: The resource group names for which the policy assignments need to happen, This is a comma seperated string
* policy_assignment_location: The location to be associated with the policy assignment
* user_assigned_identity_name: The name of the user assigned managed identity to be associated with the policy assignments
* user_assigned_identity_rg: The resource group name where the user assigned managed identity exists

## Setup/Bootstrap

### Prerequisites

* Azure Subscription
* Service Principal / Service Connection to be used for the Azure Pipelines/Terraform
* Managed Identity for policy assignments
* Storage Container for the Terraform State File

### Service Principal / Service Connection creation

A Service Principal / Service Connection is required for the Azure Pipelines to authenticate to Azure. The Service Principal / Service Connection needs to have the following permissions:
* Permissions to manage the required resources in the subscription. 
* Permissions to create Policy Definitions and Policy Assignment (Resource Policy Contributor role)) 

### Terraform Backend configuration

Terraform stores the state of the resources it manages in a state file. The state file is used by Terraform to map real world resources to the configuration, and to keep track of metadata. The state file is stored locally by default, but it can also be stored remotely, which works better in a team environment. In our case the state file is stored in an Azure Storage Account. In the Create and Destroy Azure Pipelines the backend state is configured using the following command:
    
    ```bash
        terraform init \
          -backend=true \
          -backend-config="resource_group_name=terraform-backend-policy-test-rg" \
          -backend-config="storage_account_name=tfbackendpoltest" \
          -backend-config="container_name=tfbcontainer" \
          -backend-config="key=hcipolicytest.tfstate"
    ```

The above command configures the backend state to be stored in the resource group terraform-backend-policy-test-rg, the storage account tfbackendpoltest, in the container tfbcontainer, with the key hcipolicytest.tfstate. The resource group, storage account and container need to be created before running the above command. When setting these resources up in a new subscription, please remember to change the resource group name, storage account name, container in the Azure Pipelines, with the actual resources created in the subscription.

### Modifying the Azure Pipelines with service connection and Terraform Backend configuration

The Azure Pipelines need to be modified to use the Service Connection created in the previous step, and the Terraform Backend configuration.