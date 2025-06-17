output "resource_group_name" {
  description = "The name of the created Resource Group"
  value       = module.resource_group.rg_name
}

output "vnet1_name" {
  description = "Name of the first Virtual Network"
  value       = module.vnet1.vnet_name
}

output "vnet2_name" {
  description = "Name of the second Virtual Network"
  value       = module.vnet2.vnet_name
}
