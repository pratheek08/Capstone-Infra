terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.80.0"
    }
  }
}

#terraform provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

#Resource group Module 
module "resource_group" {
  source      = "./Modules/Resource_group"
  rg_name     = var.rg_name
  location    = var.location
}

#Virtual network one Module
module "vnet1" {
  source              = "./Modules/VirtualNetwork"
  vnet_name           = var.vnet1_name
  address_space       = var.vnet1_address_space
  subnet_prefixes     = var.vnet1_subnet_prefixes
  subnet_names        = var.vnet1_subnet_names
  location            = var.location
  resource_group_name = module.resource_group.rg_name
  depends_on = [module.resource_group]
}

#Virtual network two module
module "vnet2" {
  source              = "./Modules/VirtualNetwork"
  vnet_name           = var.vnet2_name
  address_space       = var.vnet2_address_space
  subnet_prefixes     = var.vnet2_subnet_prefixes
  subnet_names        = var.vnet2_subnet_names
  location            = var.location
  resource_group_name = module.resource_group.rg_name
  depends_on = [module.resource_group]
}
