output "vnet_name" {
  value = azurerm_virtual_network.this.name
}
output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  value = azurerm_subnet.subnets[*].id
}
