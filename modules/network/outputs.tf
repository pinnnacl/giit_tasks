output "vnet_id" { value = azurerm_virtual_network.vnet.id }
output "aks_subnet_id" { value = azurerm_subnet.aks_subnet.id }
output "bastion_subnet_id" { value = azurerm_subnet.bastion_subnet.id }
output "aks_nsg_id" { value = azurerm_network_security_group.aks_nsg.id }
output "bastion_nsg_id" { value = azurerm_network_security_group.bastion_nsg.id }