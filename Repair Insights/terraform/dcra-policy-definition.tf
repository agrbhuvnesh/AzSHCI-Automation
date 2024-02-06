resource "azurerm_policy_definition" "dcra_policy_defintion" {
  name         = "tftest_dcra_policy"
  display_name = "tftest_dcra_policy"
  description  = "Associates data collection rule HCI cluster nodes"
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
          "equals": "Microsoft.HybridCompute/machines"
        },
        "then": {
          "effect": "[parameters('effect')]",
          "details": {
            "type": "Microsoft.Insights/dataCollectionRuleAssociations",
            "name": "[concat(field('name'), '-dataCollectionRuleAssociations')]",
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "deployment": {
              "properties": {
                "mode": "incremental",
                "template": {
                  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                    "machineName": {
                      "type": "string",
                      "metadata": {
                        "description": "The name of the machine."
                      }
                    },
                    "dataCollectionResourceId": {
                      "type": "string",
                      "metadata": {
                        "description": "Resource Id of the DCR"
                      }
                    }
                  },
                  "resources": [
                    {
                      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
                      "apiVersion": "2022-06-01",
                      "name": "[concat(parameters('machineName'), '-dataCollectionRuleAssociations')]",
                      "scope": "[format('Microsoft.HybridCompute/machines/{0}', parameters('machineName'))]",
                      "properties": {
                        "description": "Association of data collection rule. Deleting this association will break the data collection for this machine",
                        "dataCollectionRuleId": "[parameters('dataCollectionResourceId')]"
                      }
                    }
                  ]
                },
                "parameters": {
                  "machineName": {
                    "value": "[field('Name')]"
                  },
                  "dataCollectionResourceId": {
                    "value": "[parameters('dcrResourceId')]"
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
    },
    "dcrResourceId": {
        "type": "String",
        "metadata": {
        "displayName": "dcrResourceId",
        "description": "Resource Id of the DCR"
        }
    }
  }
PARAMETERS
}