resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "defaultnp"
    node_count     = var.default_node_count
    vm_size        = var.node_vm_size
    vnet_subnet_id = module.vnet1.subnet_ids
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    network_policy = "azure"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "subnet_b_pools" {
  count              = 3
  name               = "np${count.index + 1}"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size            = var.node_vm_size
  node_count         = var.additional_node_count
  vnet_subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]
  mode               = "User"
  #orchestrator_version = var.kubernetes_version
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}