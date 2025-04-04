targetScope = 'subscription'

param paramnname string


resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: paramnname
  location: 'westeurope'
}


