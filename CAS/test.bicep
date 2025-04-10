
param paramnname string

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: paramnname
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}



