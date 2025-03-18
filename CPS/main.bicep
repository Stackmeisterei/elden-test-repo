





resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet'

  location: 'westeurope'
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
