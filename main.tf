terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.105"
    }
  }
  backend "azurerm" {
    resource_group_name  = "storage-backend-rg"
    storage_account_name = "statefileterraform24732"      # Must be globally unique
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
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
  location            = var.vnet1_location
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
  location            = var.vnet2_location
  resource_group_name = module.resource_group.rg_name
  depends_on = [module.resource_group]
}

# VNet Peering: vnet1 --> vnet2
module "vnet1_to_vnet2" {
  source              = "./Modules/VnetPeering"
  peering_name        = "vnet1-to-vnet2"
  resource_group_name = module.resource_group.rg_name
  source_vnet_name    = module.vnet1.vnet_name
  remote_vnet_id      = module.vnet2.vnet_id
  depends_on = [module.vnet1]
}

# VNet Peering: vnet2 --> vnet1
module "vnet2_to_vnet1" {
  source              = "./Modules/VnetPeering"
  peering_name        = "vnet2-to-vnet1"
  resource_group_name = module.resource_group.rg_name
  source_vnet_name    = module.vnet2.vnet_name
  remote_vnet_id      = module.vnet1.vnet_id
  depends_on = [module.vnet2]
}


module "appgw1" {
  source              = "./Modules/Applicationgateway"
  name                = "appgw-prod"
  location            = var.vnet1_location
  resource_group_name = module.resource_group.rg_name
  subnet_id           = module.vnet1.subnet_ids[2]  # appgw-subnet
  depends_on = [module.vnet1]
}

module "appgw2" {
  source              = "./Modules/Applicationgateway"
  name                = "appgw-dev"
  location            = var.vnet2_location
  resource_group_name = module.resource_group.rg_name
  subnet_id           = module.vnet2.subnet_ids[2]  # appgw-subnet
  depends_on = [module.vnet2]
}


# ACR
module "acr" {
  source              = "./Modules/ACR"
  acr_name            = var.acr_name
  resource_group_name = module.resource_group.rg_name
  location            = var.vnet1_location
  depends_on = [module.resource_group]
}

# Traffic Manager
module "traffic_manager" {
  source              = "./Modules/TrafficManager"
  profile_name        = "global-tm"
  dns_name            = "my-global-aks"
  resource_group_name = module.resource_group.rg_name

  primary_ip   = module.appgw1.public_ip
  primary_location    = var.vnet1_location

  
  secondary_ip = module.appgw2.public_ip
  secondary_location  = var.vnet2_location
}

# AKS in VNet 1
module "aks1" {
  source                = "./Modules/AKS"
  cluster_name          = "aks-cluster-vnet1"
  resource_group_name   = module.resource_group.rg_name
  location              = var.vnet1_location
  subnet_ids            = [module.vnet1.subnet_ids[0], module.vnet1.subnet_ids[1]]
  acr_id                = module.acr.acr_id
  node_vm_size          = var.node_vm_size
  default_node_count    = var.default_node_count
  additional_node_count = var.additional_node_count
  // kubernetes_version    = var.kubernetes_version
  depends_on = [module.acr]
}

# AKS in VNet 2
module "aks2" {
  source                = "./Modules/AKS"
  cluster_name          = "aks-cluster-vnet2"
  resource_group_name   = module.resource_group.rg_name
  location              = var.vnet2_location
  subnet_ids            = [module.vnet2.subnet_ids[0], module.vnet2.subnet_ids[1]]
  acr_id                = module.acr.acr_id
  node_vm_size          = var.node_vm_size
  default_node_count    = var.default_node_count
  additional_node_count = var.additional_node_count
  // kubernetes_version    = var.kubernetes_version
  depends_on = [module.acr]
}

