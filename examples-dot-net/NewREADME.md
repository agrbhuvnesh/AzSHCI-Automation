# Microsoft Azure Stack HCI management client library for .NET

Microsoft Azure VMware Solution is a VMware validated solution with ongoing validation and testing of enhancements and upgrades. Microsoft manages and maintains the private cloud infrastructure and software. It allows you to focus on developing and running workloads in your private clouds to deliver business value.

This library supports managing Microsoft Azure Stack HCI resources.

This library follows the [new Azure SDK guidelines](https://azure.github.io/azure-sdk/general_introduction.html), and provides many core capabilities:

    - Support MSAL.NET, Azure.Identity is out of box for supporting MSAL.NET.
    - Support [OpenTelemetry](https://opentelemetry.io/) for distributed tracing.
    - HTTP pipeline with custom policies.
    - Better error-handling.
    - Support uniform telemetry across all languages.

## Getting started

### Install the package

Install the Azure Stack HCI management library for .NET with [NuGet](https://www.nuget.org/):

```dotnetcli
dotnet add package Azure.ResourceManager.Hci
```

### Prerequisites

* You must have an [Microsoft Azure subscription](https://azure.microsoft.com/free/dotnet/).

### Authenticate the Client

To create an authenticated client and start interacting with Microsoft Azure resources, see the [quickstart guide here](https://github.com/Azure/azure-sdk-for-net/blob/main/doc/dev/mgmt_quickstart.md).

## Key concepts

Key concepts of the Microsoft Azure SDK for .NET can be found [here](https://azure.github.io/azure-sdk/dotnet_introduction.html).

## Documentation

Documentation is available to help you learn how to use this package:

- [Quickstart](https://github.com/Azure/azure-sdk-for-net/blob/main/doc/dev/mgmt_quickstart.md).
- [API References](https://docs.microsoft.com/dotnet/api/?view=azure-dotnet).
- [Authentication](https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/identity/Azure.Identity/README.md).

## Examples

### Extension Management  

##### Prerequisites
1. Get the Azure token

```C# Snippet: 
            TokenCredential cred = new DefaultAzureCredential();
            ArmClient client = new ArmClient(cred);
```
2. Update the parameters given below
```C# Snippet:
            string subscription = "00000000-0000-0000-0000-000000000000"; # Replace with your subscription ID
            string resourceGroupName = "hcicluster-rg"; # Replace with your resource group name
            string clusterName = "HCICluster"; # Replace with your cluster name
            string arcSettingName = "HCIArcSettingName"; # Replace with your Arc Setting Name
            string extensionName = "MicrosoftMonitoringAgent"; # Replace with your extension name
```
3. Get Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcExtensionResourceId = ArcExtensionResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName, extensionName);
            ArcExtensionResource arcExtension = client.GetArcExtensionResource(arcExtensionResourceId);
```

#### Installing Extensions as part of enabling capabilities

##### Prerequisites

1. Get the Azure token

```C# Snippet: 
            TokenCredential cred = new DefaultAzureCredential();
            ArmClient client = new ArmClient(cred);
```
2. Update the parameters given below
```C# Snippet:
            string subscription = "00000000-0000-0000-0000-000000000000"; # Replace with your subscription ID
            string resourceGroupName = "hcicluster-rg"; # Replace with your resource group name
            string clusterName = "HCICluster"; # Replace with your cluster name
            string arcSettingName = "HCIArcSettingName"; # Replace with your Arc Setting Name
```
3. Get Arc Setting Resource

```C# Snippet: 
            ResourceIdentifier arcSettingResourceId = ArcSettingResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName);
            ArcSettingResource arcSetting = client.GetArcSettingResource(arcSettingResourceId);
```

##### Install AMA

1. Create the Payload

```C# Snippet:
            // invoke the operation

            string extensionName = "AzureMonitorWindowsAgent";
            ArcExtensionData data = new ArcExtensionData()
            {
                Publisher = "Microsoft.Azure.Monitor",
                ArcExtensionType = "AzureMonitorWindowsAgent",
                TypeHandlerVersion = "1.10",
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["workspaceId"] = "xx"
                }),
                ProtectedSettings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["workspaceKey"] = "xx" 
                }),
                EnableAutomaticUpgrade = false,
            };
```

2. Create the Extension

```C# Snippet:
           ArmOperation<ArcExtensionResource> lro = await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data);
           ArcExtensionResource result = lro.Value;
```

3. Confirmation of the Operation

```C# Snippet:
           ArcExtensionData resourceData = result.Data;
           Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

##### Install WAC
1. Enable Connectivity
```C# Snippet:
           ArcSettingPatch patch = new ArcSettingPatch()
                       {
                             ConnectivityProperties = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                            {
                                ["enabled"] = true
                            })
                            
                        };
            ArcSettingResource result1 = await arcSetting.UpdateAsync(patch);

```
2. Create the Payload

```C# Snippet:
            // invoke the operation

            string extensionName = "AzureMonitorWindowsAgent";
            ArcExtensionData data = new ArcExtensionData()
            {
                Publisher = "Microsoft.Azure.Monitor",
                ArcExtensionType = "AzureMonitorWindowsAgent",
                TypeHandlerVersion = "1.10",
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["port"] = "6516"
                }),
                EnableAutomaticUpgrade = false,
            };
```
3. Create the Extension

```C# Snippet:
           ArmOperation<ArcExtensionResource> lro = await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data);
           ArcExtensionResource result = lro.Value;
```

4. Confirmation of the Operation

```C# Snippet:
           ArcExtensionData resourceData = result.Data;
           Console.WriteLine($"Succeeded on id: {resourceData.Id}");
 
 ```
 
##### Install ASR
1. Create the Payload

```C# Snippet:
            // invoke the operation

            string extensionName = "AzureMonitorWindowsAgent";
            ArcExtensionData data = new ArcExtensionData()
            {
                Publisher = "Microsoft.Azure.Monitor",
                ArcExtensionType = "AzureMonitorWindowsAgent",
                TypeHandlerVersion = "1.10",
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["SiteId"]= "xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx",
            ["SiteName"]= "testSite",
                }),
                EnableAutomaticUpgrade = false,
            };
```

2. Create the Extension

```C# Snippet:
           ArmOperation<ArcExtensionResource> lro = await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data);
           ArcExtensionResource result = lro.Value;
```

3. Confirmation of the Operation

```C# Snippet:
           ArcExtensionData resourceData = result.Data;
           Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```


#### Extension upgrade

1. Invoke Upgrade operation

```C# Snippet: 
            ExtensionUpgradeContent content = new ExtensionUpgradeContent()
            {
                TargetVersion = "1.0.18062.0",
            };
            await arcExtension.UpgradeAsync(WaitUntil.Completed, content);


```

2. Confirmation of Operation

```C# Snippet: 
            Console.WriteLine($"Upgradation of Extension Successful!");
```

#### Installing azure- managed default extensions

#### Deleting an ARC Extension

1. Invoke the delete operation

```C# Snippet: 
            arcExtension.DeleteAsync(WaitUntil.Completed);
```

2. Confirmation of Delete Operation

```C# Snippet: 
            Console.WriteLine($"The ARC Extension has been deleted successfully!");
```

#### Extension update with update center

### HCI Cluster Management  

##### Prerequisites
1. Get the Azure token

```C# Snippet: 
            TokenCredential cred = new DefaultAzureCredential();
            ArmClient client = new ArmClient(cred);
```
2. Update the parameters given below
```C# Snippet:
            string subscription = "00000000-0000-0000-0000-000000000000"; # Replace with your subscription ID
            string resourceGroupName = "hcicluster-rg"; # Replace with your resource group name
            string clusterName = "HCICluster"; # Replace with your cluster name
```
3. Get Hci Cluster Resource

```C# Snippet: 
            ResourceIdentifier hciClusterResourceId = HciClusterResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName);
            HciClusterResource hciCluster = client.GetHciClusterResource(hciClusterResourceId);
```


#### View HCI Clusters

##### Get Single HCI Cluster using Cluster Name

1. Invoke the Get Operation

```C# Snippet: 
            HciClusterResource result = hciCluster.GetAsync().Result;
```
2. For confirmation we will print the id retrieved from result

```C# Snippet: 
            ArcExtensionData resourceData = result.Data;
            Console.WriteLine($"The Cluster Resource was successfully retrieved with ID: {resourceData.Id}");
```

#### Delete Single HCI cluster 

1. Invoke the Delete Operation

```C# Snippet: 
            await hciCluster.DeleteAsync(WaitUntil.Completed);
```
2. Confirmation of the Operation

```C# Snippet: 
            Console.WriteLine($"The delete operation was successful!");
```

#### Delete all HCI Clusters in a Resource Group
1. After Updating Parameters, get the HCI Cluster Resource Collection

```C# Snippet: 
            ResourceIdentifier resourceGroupResourceId = ResourceGroupResource.CreateResourceIdentifier(subscriptionId, resourceGroupName);
            ResourceGroupResource resourceGroupResource = client.GetResourceGroupResource(resourceGroupResourceId);

            // get the collection of this HciClusterResource
            HciClusterCollection collection = resourceGroupResource.GetHciClusters();
```
2. Calling the delete function for all Cluster Resources in the collection

```C# Snippet: 
            await foreach (HciClusterResource item in collection.GetAllAsync())
            {
                // delete the item

                await item.DeleteAsync(WaitUntil.Completed);
            }
```
3. Printing the Confirmation Text

```C# Snippet: 
            Console.WriteLine($"The delete operation on Hci Cluster Collection was successful!");
```

#### Update HCI Cluster Properties

1. Invoke the Update Operation

```C# Snippet: 
            HciClusterPatch patch = new HciClusterPatch()
            {
                Tags =
                {
                ["tag1"] = "value1",
                ["tag2"] = "value2",
                },
                CloudManagementEndpoint = "https://98294836-31be-4668-aeae-698667faf99b.waconazure.com",
                DesiredProperties = new HciClusterDesiredProperties()
                {
                    WindowsServerSubscription = WindowsServerSubscription.Enabled,
                    DiagnosticLevel = HciClusterDiagnosticLevel.Basic,
                },
                ManagedServiceIdentityType = HciManagedServiceIdentityType.SystemAssigned,
            };
            HciClusterResource result = await hciCluster.UpdateAsync(patch);
```

2. For confirmation we will print the id retrieved from result

```C# Snippet: 
            ArcExtensionData resourceData = result.Data;
            Console.WriteLine($"Update Operation Succeeded for Cluster ID: {resourceData.Id}");
```

#### Enable Azure Hybrid Benefits  

1. Invoke the Operation to Extend Azure Hybrid Benefit

```C# Snippet: 
            SoftwareAssuranceChangeContent content = new SoftwareAssuranceChangeContent()
            {
                SoftwareAssuranceIntent = SoftwareAssuranceIntent.Enable,
            };
            ArmOperation<HciClusterResource> lro =  hciCluster.ExtendSoftwareAssuranceBenefitAsync(WaitUntil.Completed, content).Result;
            HciClusterResource result = lro.Value;
```


2. For confirmation we will print the id from result

```C# Snippet: 
            ArcExtensionData resourceData = result.Data;
            Console.WriteLine($"Software Assurance Benefits Succeessfully Extended to Cluster ID: {resourceData.Id}");
```

Code samples for using the management library for .NET can be found in the following locations
- [.NET Management Library Code Samples](https://aka.ms/azuresdk-net-mgmt-samples)


## Troubleshooting

-   File an issue via [GitHub Issues](https://github.com/Azure/azure-sdk-for-net/issues).
-   Check [previous questions](https://stackoverflow.com/questions/tagged/azure+.net) or ask new ones on Stack Overflow using Azure and .NET tags.

## Next steps

For more information about Microsoft Azure SDK, see [this website](https://azure.github.io/azure-sdk/).

## Contributing

For details on contributing to this repository, see the [contributing
guide][cg].

This project welcomes contributions and suggestions. Most contributions
require you to agree to a Contributor License Agreement (CLA) declaring
that you have the right to, and actually do, grant us the rights to use
your contribution. For details, visit <https://cla.microsoft.com>.

When you submit a pull request, a CLA-bot will automatically determine
whether you need to provide a CLA and decorate the PR appropriately
(for example, label, comment). Follow the instructions provided by the
bot. You'll only need to do this action once across all repositories
using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct][coc]. For
more information, see the [Code of Conduct FAQ][coc_faq] or contact
<opencode@microsoft.com> with any other questions or comments.

<!-- LINKS -->
[cg]: https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/resourcemanager/Azure.ResourceManager/docs/CONTRIBUTING.md
[coc]: https://opensource.microsoft.com/codeofconduct/
[coc_faq]: https://opensource.microsoft.com/codeofconduct/faq/
