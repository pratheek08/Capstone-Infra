output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  value = azurerm_subnet.subnets[*].id
}
