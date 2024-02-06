resource "azurerm_policy_definition" "install_ama" {
  name         = "tftest_ama_policy"
  display_name = "tftest_ama_policy"
  description  = "Installs AMA extension on HCI cluster"
  policy_type  = "Custom"
  mode         = "All"
  metadata     = <<METADATA
    {
    "category": "Azure Stack Edge"
    }

METADATA 

  policy_rule = <<POLICY_RULE
  {
  "if": {
          "field": "type",
          "equals": "Microsoft.AzureStackHCI/clusters"
        },
        "then": {
          "effect": "[parameters('effect')]",
          "details": {
            "type": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions",
            "name": "[concat(field('name'), '/default/AzureMonitorWindowsAgent')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "existenceCondition": {
              "field": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions/extensionParameters.type",
              "equals": "AzureMonitorWindowsAgent"
            },
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "clusterName": {
                      "type": "string",
                      "metadata": {
                        "description": "The name of Cluster."
                      }
                    }
                  },
                  "resources": [
                    {
                      "type": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions",
                      "apiVersion": "2023-08-01",
                      "name": "[concat(parameters('clusterName'), '/default/AzureMonitorWindowsAgent')]",
                      "properties": {
                        "extensionParameters": {
                          "publisher": "Microsoft.Azure.Monitor",
                          "type": "AzureMonitorWindowsAgent",
                          "autoUpgradeMinorVersion": false,
                          "enableAutomaticUpgrade": false
                        }
                      }
                    }
                  ]
                },
                "parameters": {
                  "clusterName": {
                    "value": "[field('Name')]"
                  }
                }
              }
            }
          }
        }
 }
POLICY_RULE

  parameters = <<PARAMETERS
  {
    "effect": {
          "type": "String",
          "metadata": {
            "displayName": "Effect",
            "description": "Enable or disable the execution of the policy"
          },
          "allowedValues": [
            "DeployIfNotExists",
            "Disabled"
          ],
          "defaultValue": "DeployIfNotExists"
        }
  }
PARAMETERS
}