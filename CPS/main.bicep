




 module vnet2 'br/stackmeisterei:virtualnetwork:0.1' = {
  name: 'vnet'
  params: {
    paramAddressPrefixes: ['10.0.0.0/16']
    paramSubnets: [
       {
        name: 'subnet1'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
       }
    ]
    paramVirtualNetworkName: 'vnet'
    location: resourceGroup().location
  }
}
