# Hybrid Connection Relay Authorization Rules `[Microsoft.Relay/namespaces/hybridConnections/authorizationRules]`

This module deploys authorization rules for a hybrid connection relay.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Relay/namespaces/hybridConnections/authorizationRules` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/hybridConnections/authorizationRules) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the relay namepace hybrid connection. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `hybridConnectionName` | string | The name of the parent Relay Namespace Hybrid Connection. Required if the template is used in a standalone deployment. |
| `namespaceName` | string | The name of the parent Relay Namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `rights` | array | `[]` | `[Listen, Manage, Send]` | The rights associated with the rule. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |
| `resourceGroupName` | string | The name of the Resource Group the authorization rule was created in. |
| `resourceId` | string | The Resource ID of the authorization rule. |

## Cross-referenced modules

_None_
