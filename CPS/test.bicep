param workflows_logic_app_test2_name string = 'logic-app-test2'
param connections_keyvault_externalid string = '/subscriptions/2c0e1d00-15eb-4c13-93e6-ea9c4ed3f98a/resourceGroups/logic-app-test/providers/Microsoft.Web/connections/keyvault'
param connections_keyvault_name string = 'keyvault'



resource connections_keyvault_name_resource 'Microsoft.Web/connections@2018-07-01-preview' = {
  name: connections_keyvault_name
  location: 'westeurope'
  kind: 'V1'
  properties: {
    displayName: 'new_conn_333'
    statuses: [
      {
        status: 'Ready'
      }
    ]
    customParameterValues: {}
    parameterValues: {
      vaultName: 'github-ghcr-pat'
      authentication: {
        type: 'ManagedServiceIdentity'
        identity: {
          type: 'SystemAssigned'
          resourceId: workflows_logic_app_test2_name_resource.id
        }
      }
    }

    api: {
      name: connections_keyvault_name
      displayName: 'Azure Key Vault'
      description: 'Azure Key Vault is a service to securely store and access secrets.'
      id: '/subscriptions/2c0e1d00-15eb-4c13-93e6-ea9c4ed3f98a/providers/Microsoft.Web/locations/westeurope/managedApis/keyvault'
      type: 'Microsoft.Web/locations/managedApis'
    }
       testLinks: []
  }
}


resource workflows_logic_app_test2_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_logic_app_test2_name
  location: 'westeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Receive_Github_Payload: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            method: 'POST'
          }
        }
      }
      actions: {
        Dispatch_GitHub_Action: {
          runAfter: {
            Get_GitHub_PAT: [
              'Succeeded'
            ]
          }
          type: 'Http'
          inputs: {
            uri: 'https://api.github.com/repos/Stackmeisterei/elden-test-project/dispatches'
            method: 'POST'
            headers: {
              Accept: 'application/vnd.github.v3+json'
              Authorization: 'Bearer @{body(\'Get_GitHub_PAT\')?[\'value\']}'
            }
            body: {
              event_type: 'package_push_@{triggerBody()?[\'tag\']}'
              client_payload: {
                tag: '@{triggerBody()?[\'tag\']}'
                image: '@{triggerBody()?[\'image\']}'
                sha: '@{triggerBody()?[\'sha\']}'
              }
            }
          }
          runtimeConfiguration: {
            contentTransfer: {
              transferMode: 'Chunked'
            }
          }
        }
        Get_GitHub_PAT: {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'keyvault\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/secrets/@{encodeURIComponent(\'github-pat\')}/value'
          }
          runtimeConfiguration: {
            secureData: {
              properties: [
                'inputs'
                'outputs'
              ]
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          keyvault: {
            id: '/subscriptions/2c0e1d00-15eb-4c13-93e6-ea9c4ed3f98a/providers/Microsoft.Web/locations/westeurope/managedApis/keyvault'
            connectionId: connections_keyvault_externalid
            connectionName: 'keyvault'
            connectionProperties: {
              authentication: {
                type: 'ManagedServiceIdentity'
              }
            }
          }
        }
      }
    }
  }
}
