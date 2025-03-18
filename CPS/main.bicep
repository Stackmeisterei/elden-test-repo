




resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'myTestVnet'
  location: 'East US'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'mySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
