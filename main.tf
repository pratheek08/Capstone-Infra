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


// module "appgw1" {
//   source              = "./Modules/Applicationgateway"
//   name                = "appgw-prod"
//   location            = var.vnet1_location
//   resource_group_name = module.resource_group.rg_name
//   subnet_id           = module.vnet1.subnet_ids[2]  # appgw-subnet
//   depends_on = [module.vnet1]
// }

// module "appgw2" {
//   source              = "./Modules/Applicationgateway"
//   name                = "appgw-dev"
//   location            = var.vnet2_location
//   resource_group_name = module.resource_group.rg_name
//   subnet_id           = module.vnet2.subnet_ids[2]  # appgw-subnet
//   depends_on = [module.vnet2]
// }

// module "lb1" {
//   source              = "./Modules/LoadBalancer"
//   name                = "lb-prod"
//   location            = var.vnet1_location
//   resource_group_name = module.resource_group.rg_name
//   backend_port        = 30080
// }

// module "lb2" {
//   source              = "./Modules/LoadBalancer"
//   name                = "lb-dev"
//   location            = var.vnet2_location
//   resource_group_name = module.resource_group.rg_name
//   backend_port        = 30080
// }


# ACR
module "acr" {
  source              = "./Modules/ACR"
  acr_name            = var.acr_name
  resource_group_name = module.resource_group.rg_name
  location            = var.vnet1_location
  depends_on = [module.resource_group]
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

resource "azurerm_public_ip" "ingress_ip_1" {
  name                = "ingress-ip-vnet1"
  location            = var.vnet1_location
  resource_group_name = module.resource_group.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "ingress_ip_2" {
  name                = "ingress-ip-vnet2"
  location            = var.vnet2_location
  resource_group_name = module.resource_group.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "null_resource" "install_ingress_aks1" {
  depends_on = [module.aks1, azurerm_public_ip.ingress_ip_1]

  provisioner "local-exec" {
    command = <<EOT
      az aks get-credentials -g ${module.resource_group.rg_name} -n aks-cluster-vnet1 --overwrite-existing

      helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
      helm repo update

      helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
        --namespace ingress-nginx --create-namespace \
        --set controller.service.loadBalancerIP="${azurerm_public_ip.ingress_ip_1.ip_address}" \
        --set controller.service.annotations."service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"="${module.resource_group.rg_name}"
    EOT
  }
}

resource "null_resource" "install_ingress_aks2" {
  depends_on = [module.aks2, azurerm_public_ip.ingress_ip_2]

  provisioner "local-exec" {
    command = <<EOT
      az aks get-credentials -g ${module.resource_group.rg_name} -n aks-cluster-vnet2 --overwrite-existing

      helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
      helm repo update

      helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
        --namespace ingress-nginx --create-namespace \
        --set controller.service.loadBalancerIP="${azurerm_public_ip.ingress_ip_2.ip_address}" \
        --set controller.service.annotations."service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"="${module.resource_group.rg_name}"
    EOT
  }
}



# Traffic Manager
module "traffic_manager" {
  source              = "./Modules/TrafficManager"
  profile_name        = "global-tm"
  dns_name            = "my-global-aks"
  resource_group_name = module.resource_group.rg_name
  primary_ip          = azurerm_public_ip.ingress_ip_1.ip_address
  primary_location    = var.vnet1_location
  secondary_ip        = azurerm_public_ip.ingress_ip_2.ip_address
  secondary_location  = var.vnet2_location
}

