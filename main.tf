terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

#terraform provider
provider "azurerm" {
  features {}
}

#Resource group Module 
module "resource_group" {
  source      = "./modules/resource_group"
  rg_name     = var.rg_name
  location    = var.location
}

#Virtual network one Module
module "vnet1" {
  source              = "./modules/vnet"
  vnet_name           = var.vnet1_name
  address_space       = var.vnet1_address_space
  subnet_prefixes     = var.vnet1_subnet_prefixes
  subnet_names        = var.vnet1_subnet_names
  location            = var.location
  resource_group_name = module.resource_group.rg_name
}

#Virtual network two module
module "vnet2" {
  source              = "./modules/vnet"
  vnet_name           = var.vnet2_name
  address_space       = var.vnet2_address_space
  subnet_prefixes     = var.vnet2_subnet_prefixes
  subnet_names        = var.vnet2_subnet_names
  location            = var.location
  resource_group_name = module.resource_group.rg_name
}
