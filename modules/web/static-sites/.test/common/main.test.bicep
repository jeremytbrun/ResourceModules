targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.web.staticsites-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wsscom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    siteName: 'dep-<<namePrefix>>-fa-${serviceShort}'
    serverFarmName: 'dep-<<namePrefix>>-sf-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    allowConfigFileUpdates: true
    enterpriseGradeCdnStatus: 'Disabled'
    lock: 'CanNotDelete'
    privateEndpoints: [
      {
        service: 'staticSites'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            nestedDependencies.outputs.privateDNSZoneResourceId
          ]
        }
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    sku: 'Standard'
    stagingEnvironmentPolicy: 'Enabled'
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    appSettings: {
      foo: 'bar'
      setting: 1
    }
    functionAppSettings: {
      foo: 'bar'
      setting: 1
    }
    linkedBackend: {
      resourceId: nestedDependencies.outputs.siteResourceId
    }
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
