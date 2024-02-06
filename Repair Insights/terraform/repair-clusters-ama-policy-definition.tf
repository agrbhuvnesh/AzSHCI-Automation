resource "azurerm_policy_definition" "repair_cluster_ama" {
  name         = "tftest-msft-repair-cluster-ama"
  display_name = "tftest Microsoft - RepairClusterAMA Sample"
  description  = "tftest RepairClusterAMA Guest Configuration policy sample created by Microsoft 12/14/2023 12:46:00 PM"
  policy_type  = "Custom"
  mode         = "Indexed"
  metadata     = <<METADATA
    {
    "category": "Guest Configuration"
    }

METADATA 

  policy_rule = <<POLICY_RULE
  {
  "then": { 
        "effect": "deployIfNotExists", 
        "details": { 
          "type": "Microsoft.GuestConfiguration/guestConfigurationAssignments", 
          "existenceCondition": { 
            "allOf": [ 
              { 
                "field": "Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus", 
                "equals": "Compliant" 
              }, 
              { 
                "field": "Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash", 
                "equals": "[base64(concat('[RepairClusterAMA]RepairClusterAMAInstanceName;Path', '=', parameters('Path'), ',', '[RepairClusterAMA]RepairClusterAMAInstanceName;Content', '=', parameters('Content')))]" 
              } 
            ] 
          }, 
          "roleDefinitionIds": [ 
            "/providers/Microsoft.Authorization/roleDefinitions/088ab73d-1256-47ae-bea9-9de8e7131f31" 
          ], 
          "deployment": { 
            "properties": { 
              "parameters": { 
                "type": { 
                  "value": "[field('type')]" 
                }, 
                "location": { 
                  "value": "[field('location')]" 
                }, 
                "vmName": { 
                  "value": "[field('name')]" 
                }, 
                "assignmentName": { 
                  "value": "[concat('RepairClusterAMA$pid', uniqueString(policy().assignmentId, policy().definitionReferenceId))]" 
                }, 
                "Content": { 
                  "value": "[parameters('Content')]" 
                }, 
                "Path": { 
                  "value": "[parameters('Path')]" 
                } 
              }, 
              "mode": "incremental", 
              "template": { 
                "parameters": { 
                  "type": { 
                    "type": "string" 
                  }, 
                  "location": { 
                    "type": "string" 
                  }, 
                  "vmName": { 
                    "type": "string" 
                  }, 
                  "assignmentName": { 
                    "type": "string" 
                  }, 
                  "Content": { 
                    "type": "string" 
                  }, 
                  "Path": { 
                    "type": "string" 
                  } 
                }, 
                "contentVersion": "1.0.0.0", 
                "resources": [ 
                  { 
                    "type": "Microsoft.Compute/virtualMachines/providers/guestConfigurationAssignments", 
                    "properties": { 
                      "guestConfiguration": { 
                        "version": "1.0.0", 
                        "name": "RepairClusterAMA", 
                        "configurationParameter": [ 
                          { 
                            "value": "[parameters('Path')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Path" 
                          }, 
                          { 
                            "value": "[parameters('Content')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Content" 
                          } 
                        ], 
                        "contentHash": "7EA99B10AE79EA5C1456A134441270BC48F5208F3521BFBFDCAE5EF7B6A9D9BD", 
                        "contentUri": "https://guestconfiguration4.blob.core.windows.net/guestconfiguration/RepairClusterAMA.zip", 
                        "contentType": "Custom", 
                        "assignmentType": "ApplyAndAutoCorrect" 
                      } 
                    }, 
                    "location": "[parameters('location')]", 
                    "apiVersion": "2018-11-20", 
                    "name": "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]", 
                    "condition": "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]" 
                  }, 
                  { 
                    "type": "Microsoft.HybridCompute/machines/providers/guestConfigurationAssignments", 
                    "properties": { 
                      "guestConfiguration": { 
                        "version": "1.0.0", 
                        "name": "RepairClusterAMA", 
                        "configurationParameter": [ 
                          { 
                            "value": "[parameters('Path')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Path" 
                          }, 
                          { 
                            "value": "[parameters('Content')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Content" 
                          } 
                        ], 
                        "contentHash": "7EA99B10AE79EA5C1456A134441270BC48F5208F3521BFBFDCAE5EF7B6A9D9BD", 
                        "contentUri": "https://guestconfiguration4.blob.core.windows.net/guestconfiguration/RepairClusterAMA.zip", 
                        "contentType": "Custom", 
                        "assignmentType": "ApplyAndAutoCorrect" 
                      } 
                    }, 
                    "location": "[parameters('location')]", 
                    "apiVersion": "2018-11-20", 
                    "name": "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]", 
                    "condition": "[equals(toLower(parameters('type')), toLower('Microsoft.HybridCompute/machines'))]" 
                  }, 
                  { 
                    "type": "Microsoft.Compute/virtualMachineScaleSets/providers/guestConfigurationAssignments", 
                    "properties": { 
                      "guestConfiguration": { 
                        "version": "1.0.0", 
                        "name": "RepairClusterAMA", 
                        "configurationParameter": [ 
                          { 
                            "value": "[parameters('Path')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Path" 
                          }, 
                          { 
                            "value": "[parameters('Content')]", 
                            "name": "[RepairClusterAMA]RepairClusterAMAInstanceName;Content" 
                          } 
                        ], 
                        "contentHash": "7EA99B10AE79EA5C1456A134441270BC48F5208F3521BFBFDCAE5EF7B6A9D9BD", 
                        "contentUri": "https://guestconfiguration4.blob.core.windows.net/guestconfiguration/RepairClusterAMA.zip", 
                        "contentType": "Custom", 
                        "assignmentType": "ApplyAndAutoCorrect" 
                      } 
                    }, 
                    "location": "[parameters('location')]", 
                    "apiVersion": "2018-11-20", 
                    "name": "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]", 
                    "condition": "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachineScaleSets'))]" 
                  } 
                ], 
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#" 
              } 
            } 
          }, 
          "name": "[concat('RepairClusterAMA$pid', uniqueString(policy().assignmentId, policy().definitionReferenceId))]" 
        } 
      }, 
      "if": { 
        "anyOf": [ 
          { 
            "allOf": [ 
              { 
                "anyOf": [ 
                  { 
                    "field": "type", 
                    "equals": "Microsoft.Compute/virtualMachines" 
                  }, 
                  { 
                    "field": "type", 
                    "equals": "Microsoft.Compute/virtualMachineScaleSets" 
                  } 
                ] 
              }, 
              { 
                "field": "tags['aks-managed-orchestrator']", 
                "exists": "false" 
              }, 
              { 
                "field": "tags['aks-managed-poolName']", 
                "exists": "false" 
              }, 
              { 
                "anyOf": [ 
                  { 
                    "field": "Microsoft.Compute/imagePublisher", 
                    "in": [ 
                      "esri", 
                      "incredibuild", 
                      "MicrosoftDynamicsAX", 
                      "MicrosoftSharepoint", 
                      "MicrosoftVisualStudio", 
                      "MicrosoftWindowsDesktop", 
                      "MicrosoftWindowsServerHPCPack" 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "MicrosoftWindowsServer" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageSKU", 
                        "notLike": "2008*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "MicrosoftSQLServer" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "notLike": "SQL2008*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "microsoft-dsvm" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "dsvm-win*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "microsoft-ads" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "in": [ 
                          "standard-data-science-vm", 
                          "windows-data-science-vm" 
                        ] 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "batch" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "equals": "rendering-windows2016" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "center-for-internet-security-inc" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "cis-windows-server-201*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "pivotal" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "bosh-windows-server*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "Microsoft.Compute/imagePublisher", 
                        "equals": "cloud-infrastructure-services" 
                      }, 
                      { 
                        "field": "Microsoft.Compute/imageOffer", 
                        "like": "ad*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "anyOf": [ 
                          { 
                            "field": "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration", 
                            "exists": true 
                          }, 
                          { 
                            "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType", 
                            "like": "Windows*" 
                          }, 
                          { 
                            "field": "Microsoft.Compute/VirtualMachineScaleSets/osProfile.windowsConfiguration", 
                            "exists": true 
                          }, 
                          { 
                            "field": "Microsoft.Compute/virtualMachineScaleSets/virtualMachineProfile.storageProfile.osDisk.osType", 
                            "like": "Windows*" 
                          } 
                        ] 
                      }, 
                      { 
                        "anyOf": [ 
                          { 
                            "field": "Microsoft.Compute/imageSKU", 
                            "exists": false 
                          }, 
                          { 
                            "allOf": [ 
                              { 
                                "field": "Microsoft.Compute/imageOffer", 
                                "notLike": "SQL2008*" 
                              }, 
                              { 
                                "field": "Microsoft.Compute/imageSKU", 
                                "notLike": "2008*" 
                              } 
                            ] 
                          } 
                        ] 
                      } 
                    ] 
                  } 
                ] 
              } 
            ] 
          }, 
          { 
            "allOf": [ 
              { 
                "equals": true, 
                "value": "[parameters('IncludeArcMachines')]" 
              }, 
              { 
                "anyOf": [ 
                  { 
                    "allOf": [ 
                      { 
                        "field": "type", 
                        "equals": "Microsoft.HybridCompute/machines" 
                      }, 
                      { 
                        "field": "Microsoft.HybridCompute/imageOffer", 
                        "like": "windows*" 
                      } 
                    ] 
                  }, 
                  { 
                    "allOf": [ 
                      { 
                        "field": "type", 
                        "equals": "Microsoft.ConnectedVMwarevSphere/virtualMachines" 
                      }, 
                      { 
                        "field": "Microsoft.ConnectedVMwarevSphere/virtualMachines/osProfile.osType", 
                        "like": "windows*" 
                      } 
                    ] 
                  } 
                ] 
              } 
            ] 
          } 
        ] 
      }
 }
POLICY_RULE

  parameters = <<PARAMETERS
  {
    "IncludeArcMachines": { 
        "allowedValues": [ 
          "true", 
          "false" 
        ], 
        "defaultValue": "false", 
        "metadata": { 
          "description": "By selecting this option, you agree to be charged monthly per Arc connected machine.", 
          "displayName": "Include Arc connected machines", 
          "portalReview": true
        }, 
        "type": "String"
      }, 
      "Content": {  
        "defaultValue": "File content XYZ", 
        "metadata": { 
          "description": "File content", 
          "displayName": "Content" 
        }, 
        "type": "String"
      }, 
      "Path": { 
        "defaultValue": "C:\\DSC\\CreateFileXYZ.txt", 
        "metadata": { 
          "description": "Path including file name and extension", 
          "displayName": "Path" 
        }, 
        "type": "String" 
      }
  }
PARAMETERS
}