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

### Arc Extension Resource

#### Get a Arc Setting Extension Resource

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
            // the variable result is a resource, you could call other operations on this instance as well
             ArcExtensionResource result = arcExtension.GetAsync().Result;


```

4. For confirmation we will print the id retrieved from result

```C# Snippet: 
        ArcExtensionData resourceData = result.Data;
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

#### Update Arc Extension Resource

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcExtensionResourceId = ArcExtensionResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName, extensionName);
            ArcExtensionResource arcExtension = client.GetArcExtensionResource(arcExtensionResourceId);
```

4. Invoke the Update Operation

```C# Snippet: 
            ArcExtensionData data = new ArcExtensionData()
            {
                Publisher = "Microsoft.EnterpriseCloud.Monitoring",
                ArcExtensionType = "MicrosoftMonitoringAgent",
                TypeHandlerVersion = "1.10",
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["workspaceId"] = "61b09e88-b57b-49f8-a7f8-59b67739e5fb"
                }),
            };

            ArmOperation<ArcExtensionResource> lro =  arcExtension.UpdateAsync(WaitUntil.Completed, data).Result;
            ArcExtensionResource result = await lro.WaitForCompletionAsync();
```

5. For confirmation we will print the id retrieved from result

```C# Snippet: 
        ArcExtensionData resourceData = result.Data;
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

#### Delete Arc Extension Resource

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcExtensionResourceId = ArcExtensionResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName, extensionName);
            ArcExtensionResource arcExtension = client.GetArcExtensionResource(arcExtensionResourceId);
```

4. Invoke delete operation

```C# Snippet: 
            
            arcExtension.DeleteAsync(WaitUntil.Completed);
```

5. For confirmation we can print the text "Succeeded"

```C# Snippet: 
        Console.WriteLine($"Succeeded");
```

#### Upgrade Machine Extensions

1. Get azure token

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
3. Invoke upgrade operation

```C# Snippet: 
            ExtensionUpgradeContent content = new ExtensionUpgradeContent()
            {
                TargetVersion = "1.0.18062.0",
            };
            await arcExtension.UpgradeAsync(WaitUntil.Completed, content);


```

4. For confirmation we print text "Succeeded"

```C# Snippet: 
        Console.WriteLine($"Succeeded");
```

### Arc Setting Resource

#### Get a Arc Setting Resource

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
3. Get Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcSettingResourceId = ArcSettingResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName);
            ArcSettingResource arcSetting = client.GetArcSettingResource(arcSettingResourceId);
            // the variable result is a resource, you could call other operations on this instance as well
             ArcExtensionResource result = arcExtension.GetAsync().Result;


```

4. For confirmation we will print the id retrieved from result
```C# Snippet: 
        ArcExtensionData resourceData = result.Data;
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

#### Update Arc Setting Resource

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcSettingResourceId = ArcSettingResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName);
            ArcSettingResource arcSetting = client.GetArcSettingResource(arcSettingResourceId);
```

4. Invoke the Update Operation

```C# Snippet: 
            ArcSettingPatch patch = new ArcSettingPatch()
                {
                    ConnectivityProperties = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                    {
                        ["enabled"] = true
                    }),
                };
             ArcSettingResource result = arcSetting.UpdateAsync(patch).Result;
```

5. For confirmation we will print the id retrieved from result

```C# Snippet: 
        ArcExtensionData resourceData = result.Data;
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

#### Delete Arc Setting Resource

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcExtensionResourceId = ArcExtensionResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName, extensionName);
            ArcExtensionResource arcExtension = client.GetArcExtensionResource(arcExtensionResourceId);
```

4. Invoke delete operation

```C# Snippet: 
            
            arcExtension.DeleteAsync(WaitUntil.Completed);
```

5. For confirmation we can print the text "Succeeded"

```C# Snippet: 
        Console.WriteLine($"Succeeded");
```

#### Generate Password

1. Get azure token

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcExtensionResourceId = ArcExtensionResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName, extensionName);
            ArcExtensionResource arcExtension = client.GetArcExtensionResource(arcExtensionResourceId);
```

4. Invoke the operation

```C# Snippet: 
            ArcPasswordCredential result =  arcSetting.GeneratePasswordAsync().Result;
```

5. For confirmation we print text "Succeeded"

```C# Snippet: 
        Console.WriteLine($"Succeeded: {result}");
```
#### Create Arc Identity

1. Get azure token

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcExtensionResourceId = ArcExtensionResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName, extensionName);
            ArcExtensionResource arcExtension = client.GetArcExtensionResource(arcExtensionResourceId);
```

4. Invoke the operation

```C# Snippet: 
            ArmOperation<ArcIdentityResult> lro = arcSetting.CreateIdentityAsync(WaitUntil.Completed).Result;
            ArcIdentityResult result = lro.Value;
```

5. For confirmation we print text "Succeeded"

```C# Snippet: 
        Console.WriteLine($"Succeeded: {result}");
```

### Arc Setting Collection

#### List All the Setting Resources in HCI cluster

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
3. Get Arc Setting Resource

```C# Snippet: 
            ResourceIdentifier hciClusterResourceId = HciClusterResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName);
            HciClusterResource hciCluster = client.GetHciClusterResource(hciClusterResourceId);

            // get the collection of this ArcSettingResource
            ArcSettingCollection collection = hciCluster.GetArcSettings();

```

4. For confirmation we will print each of the id retrieved from result

```C# Snippet: 
            foreach (ArcSettingResource item in collection)
            {
                // the variable item is a resource, you could call other operations on this instance as well
                // but just for demo, we get its data from this resource instance
                ArcSettingData resourceData = item.Data;
                // for demo we just print out the id
                Console.WriteLine($"Succeeded on id: {resourceData.Id}");
            }

            Console.WriteLine($"Succeeded");
```

#### Get Arc Setting

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
3. Get the Arc Setting Resource

```C# Snippet: 
            ResourceIdentifier hciClusterResourceId = HciClusterResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName);
            HciClusterResource hciCluster = client.GetHciClusterResource(hciClusterResourceId);

            // get the collection of this ArcSettingResource
            ArcSettingCollection collection = hciCluster.GetArcSettings();
```

4. Invoke the Operation

```C# Snippet: 
            string arcSettingName = "default";
            ArcSettingResource result =  collection.GetAsync(arcSettingName).Result;
```

5. For confirmation we will print the id retrieved from result

```C# Snippet: 
        ArcSettingData resourceData = result.Data;
        
        // for demo we just print out the id
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

#### Check if the Arc Setting Exists

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier hciClusterResourceId = HciClusterResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName);
            HciClusterResource hciCluster = client.GetHciClusterResource(hciClusterResourceId);

            // get the collection of this ArcSettingResource
            ArcSettingCollection collection = hciCluster.GetArcSettings();
```

4. Invoke the operation

```C# Snippet: 
            
            string arcSettingName = "default";
            bool result =  collection.ExistsAsync(arcSettingName).Result;
```

5. For confirmation we can print the text "Succeeded"

```C# Snippet: 
        Console.WriteLine($"Succeeded: {result}");
```

#### Create or Update Arc Setting

1. Get azure token

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier hciClusterResourceId = HciClusterResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName);
            HciClusterResource hciCluster = client.GetHciClusterResource(hciClusterResourceId);

            // get the collection of this ArcSettingResource
            ArcSettingCollection collection = hciCluster.GetArcSettings();
```

4. Invoke the create or update operation

```C# Snippet: 
            string arcSettingName = "default";
            ArcSettingData data = new ArcSettingData();
            Console.WriteLine(data);
            Console.WriteLine(collection);
            
            ArmOperation<ArcSettingResource> lro =  collection.CreateOrUpdateAsync(WaitUntil.Completed, arcSettingName, data).Result;
            Console.WriteLine($"lro:{lro}");
            ArcSettingResource result = lro.Value;

```

4. For confirmation we print the Id

```C# Snippet: 
        ArcSettingData resourceData = result.Data;
        
        // for demo we just print out the id
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

### Arc Extension Collection

#### Get all extensions under Arc Setting Resource

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

            // get the collection of this ArcExtensionResource
            ArcExtensionCollection collection = arcSetting.GetArcExtensions();

```

4. For confirmation we will print each of the id retrieved from result

```C# Snippet: 
        foreach (ArcExtensionResource item in collection)
            {
                // the variable item is a resource, you could call other operations on this instance as well
                // but just for demo, we get its data from this resource instance
                ArcExtensionData resourceData = item.Data;
                // for demo we just print out the id
                Console.WriteLine($"Succeeded on id: {resourceData.Id}");
            }
        Console.WriteLine($"Succeeded");
```

#### Get Arc Setting Extension

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
3. Get the Arc Setting Resource

```C# Snippet: 
            ResourceIdentifier arcSettingResourceId = ArcSettingResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName);
            ArcSettingResource arcSetting = client.GetArcSettingResource(arcSettingResourceId);

            // get the collection of this ArcExtensionResource
            ArcExtensionCollection collection = arcSetting.GetArcExtensions();
```

4. Invoke the Operation

```C# Snippet: 
            string extensionName = "MicrosoftMonitoringAgent";
            ArcExtensionResource result = collection.GetAsync(extensionName).Result;
```

5. For confirmation we will print the id retrieved from result

```C# Snippet: 
        ArcExtensionData resourceData = result.Data;
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
```

#### Check if the Arc Settings Extension Exists

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcSettingResourceId = ArcSettingResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName);
            ArcSettingResource arcSetting = client.GetArcSettingResource(arcSettingResourceId);

            // get the collection of this ArcExtensionResource
            ArcExtensionCollection collection = arcSetting.GetArcExtensions();
```

4. Invoke the operation

```C# Snippet: 
            
            // invoke the operation
            string extensionName = "MicrosoftMonitoringAgent";
            bool result =  collection.ExistsAsync(extensionName).Result;
```

5. For confirmation we can print the text "Succeeded"

```C# Snippet: 
        Console.WriteLine($"Succeeded: {result}");
```

#### Create or Update Arc Extension

1. Get azure token

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
3. Get the Arc Extension Resource

```C# Snippet: 
            ResourceIdentifier arcSettingResourceId = ArcSettingResource.CreateResourceIdentifier(subscriptionId, resourceGroupName, clusterName, arcSettingName);
            ArcSettingResource arcSetting = client.GetArcSettingResource(arcSettingResourceId);

            // get the collection of this ArcExtensionResource
            ArcExtensionCollection collection = arcSetting.GetArcExtensions();
```

4. Invoke the create or update operation

```C# Snippet: 
            string extensionName = "MicrosoftMonitoringAgent";
            ArcExtensionData data = new ArcExtensionData()
            
            {
                Publisher = "Microsoft.EnterpriseCloud.Monitoring",
                ArcExtensionType = "MicrosoftMonitoringAgent",
                TypeHandlerVersion = "1.10",
                ShouldAutoUpgradeMinorVersion = false,
                Settings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["workspaceId"] = "694e3ed4-e103-40da-8082-3ddcca5ae1a4"
                }),
                ProtectedSettings = BinaryData.FromObjectAsJson(new Dictionary<string, object>()
                {
                    ["workspaceKey"] = "WSsPeIGP7ozmIl33bI+4mxexmDKeWMe3/YW0IMEicHkyd9cdTTJ9GRuJ7AmslvHSbyptsCi8lVI2yoJcyntD+Q=="
                }),
                EnableAutomaticUpgrade = false,
            };

            ArmOperation<ArcExtensionResource> lro = await collection.CreateOrUpdateAsync(WaitUntil.Completed, extensionName, data);

            Response<ArcExtensionResource> response = await lro.WaitForCompletionAsync();
                ArcExtensionResource result = response.Value;

```

4. For confirmation we print the Id

```C# Snippet: 
        ArcExtensionData resourceData = result.Data;
                Console.WriteLine(result);
        // for demo we just print out the id
        Console.WriteLine($"Succeeded on id: {resourceData.Id}");
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