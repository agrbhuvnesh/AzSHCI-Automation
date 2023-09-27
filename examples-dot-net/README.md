# Microsoft Azure Stack HCI management client library for .NET

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
            string extensionName = "AzureMonitorWindowsAgent"; # Replace with your extension name
            # Some common examples are: AzureMonitorWindowsAgent, AzureSiteRecovery, AdminCenter
```
3. Get Arc Resource

A. For Installing Extensions use this step:

Get Arc Setting Resource

```C# Snippet: 
            ResourceIdentifier arcSettingResourceId = ArcSettingResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, "default");
            ArcSettingResource arcSetting = client.GetArcSettingResource(arcSettingResourceId);
```

B. For Upgrading Extensions and Deleteing Extensions use this step:

Get Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcExtensionResourceId = ArcExtensionResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, "default", extensionName);
            ArcExtensionResource arcExtension = client.GetArcExtensionResource(arcExtensionResourceId);
```

#### Installing Extensions as part of enabling capabilities

##### Install Azure Monitor Windows Agent Extension

1. Create the Payload

```C# Snippet:
            // invoke the operation

            string extensionName = "AzureMonitorWindowsAgent";
            string publisherName = "Microsoft.Azure.Monitor";
            string arcExtensionName = "AzureMonitorWindowsAgent";
            string typeHandlerVersion = "1.10";
            string workspaceId = "xx";// workspace id for the log analytics workspace to be used with AMA extension
            string workspaceKey = "xx";// workspace key for the log analytics workspace to be used with AMA extension
            bool enableAutomaticUpgrade = false;

            ArcExtensionData data = new ArcExtensionData()
            {
                Publisher = publisherName,
                ArcExtensionType = arcExtensionName,
                TypeHandlerVersion = typeHandlerVersion,
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["workspaceId"] = workspaceId
                }),
                ProtectedSettings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["workspaceKey"] = workspaceKey
                }),
                EnableAutomaticUpgrade = enableAutomaticUpgrade,
            };
```

2. Create the Extension

```C# Snippet:
           ArcExtensionResource result = (await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data)).Value;

```

3. Confirmation of the Operation

```C# Snippet:
           ArcExtensionData resourceData = result.Data;
           Console.WriteLine($"Succeeded on id: {resourceData.Id}, name: {resourceData.Name}, extension type: {resourceData.ArcExtensionType}");
```

##### Install Windows Admin Centre Extension
1. For installing Windows Admin Center, we need to enable network connectivity first.

```C# Snippet:
           bool isEnabled = true;
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

            string extensionName = "AdminCenter";
            string publisherName = "Microsoft.AdminCenter";
            string arcExtensionType = "AdminCenter";
            string typeHandlerVersion = "1.10";
            string portNumber = "6516"; //port to be associated with WAC
            bool enableAutoUpgrade = false; // change to true to enable automatic upgrade

            ArcExtensionData data = new ArcExtensionData()
            {
                Publisher = publisherName,
                ArcExtensionType = arcExtensionType,
                TypeHandlerVersion = typeHandlerVersion,
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["port"] = portNumber
                }),
                EnableAutomaticUpgrade = enableAutoUpgrade,
            };
            ArcExtensionCollection collection = arcSetting.GetArcExtensions();
```
3. Create the Extension

```C# Snippet:
           ArcExtensionResource result = (await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data)).Value;
```

4. Confirmation of the Operation

```C# Snippet:
           ArcExtensionData resourceData = result.Data;
           Console.WriteLine($"Succeeded on id: {resourceData.Id}, name: {resourceData.Name}, extension type: {resourceData.ArcExtensionType}");
 
 ```
 
##### Install Azure Site Recovery Extension
1. Create the Payload

```C# Snippet:
            // invoke the operation

            string publisherName = "Microsoft.SiteRecovery.Dra";
            string arcExtensionType = "Windows";
            string extensionName = "AzureSiteRecovery";
            string env = "AzureCloud";
            string subscriptionId = "your SubscriptionId";
            string resourceGroup = "your ResourceGroup";
            string resourceName = "your site recovery vault name";
            string location = "your site recovery region";
            string siteId = "Id for your recovery site";
            string siteName = "ypur recovery site name";
            string policyId = "your resource id for recovery site policy";
            string pvtEndpointState = "None";
            bool enableAutoUpgrade = false;

            ArcExtensionData data = new ArcExtensionData()
            {
                Publisher = publisherName,
                ArcExtensionType = arcExtensionType,
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    {
                        "SubscriptionId": subscriptionId,
                        "Environment": env,
                        "ResourceGroup": resourceGroup,
                        "ResourceName": resourceName,
                        "Location": location,
                        "SiteId": siteId,
                        "SiteName": siteName,
                        "PolicyId": policyId,
                        "PrivateEndpointStateForSiteRecovery": pvtEndpointState
}
                }),
                EnableAutomaticUpgrade = isAutoUpgrade,
            };
```

2. Create the Extension

```C# Snippet:
           ArcExtensionResource result = (await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data)).Value;
```

3. Confirmation of the Operation

```C# Snippet:
           ArcExtensionData resourceData = result.Data;
           Console.WriteLine($"Succeeded on id: {resourceData.Id}, name: {resourceData.Name}, extension type: {resourceData.ArcExtensionType}");
```


#### Extension upgrade

1. Invoke Upgrade operation

```C# Snippet: 
            string targetVersion = "1.0.18062.0"; //replace with extension version you want to install

            ExtensionUpgradeContent content = new ExtensionUpgradeContent()
            {
                TargetVersion = targetVersion,
            };
            await arcExtension.UpgradeAsync(WaitUntil.Completed, content);


```

#### Deleting an ARC Extension

1. Invoke the delete operation

```C# Snippet: 
            arcExtension.DeleteAsync(WaitUntil.Completed);
```

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
            
```
#### Skip this step when performing an operation on all clusters of a resource group: 

3. Get Hci Cluster Resource
        
```C# Snippet: 
            string clusterName = "HCICluster"; # Replace with your cluster name,
            ResourceIdentifier hciClusterResourceId = HciClusterResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName);
            HciClusterResource hciCluster = client.GetHciClusterResource(hciClusterResourceId);
```


#### View HCI Clusters

##### Get Single HCI Cluster using Cluster Name

1. Invoke the Get Operation

```C# Snippet: 
            HciClusterResource result = hciCluster.GetAsync().Result;
```

#### Delete Single HCI cluster 

1. Invoke the Delete Operation

```C# Snippet: 
            await hciCluster.DeleteAsync(WaitUntil.Completed);
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

#### Update HCI Cluster Properties

1. Invoke the Update Operation

```C# Snippet: 
            string tag1 = "tag1";
            string val1 = "value1";

            HciClusterPatch patch = new HciClusterPatch()
            {
                Tags =
                {
                [tag1] = val1
                },
     
                DesiredProperties = new HciClusterDesiredProperties()
                {
                    WindowsServerSubscription = WindowsServerSubscription.Enabled,// It can Enabled or Disabled
                    DiagnosticLevel = HciClusterDiagnosticLevel.Basic,// It can be Basic or 
                },
            };
            HciClusterResource result = await hciCluster.UpdateAsync(patch);
```

#### Enable Azure Hybrid Benefits  

1. Invoke the Operation to Extend Azure Hybrid Benefit

```C# Snippet: 
            SoftwareAssuranceChangeContent content = new SoftwareAssuranceChangeContent()
            {
                SoftwareAssuranceIntent = SoftwareAssuranceIntent.Enable,
            };
            ArcExtensionResource result = (await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data)).Value;
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
