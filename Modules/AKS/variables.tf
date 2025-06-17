# File: Modules/AKS/variables.tf
variable "cluster_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "subnet_ids" {
  type = list(string)
}
variable "acr_id" {}
variable "node_vm_size" {
  default = "Standard_DS2_v2"
}
variable "default_node_count" {
  default = 1
}
variable "additional_node_count" {
  default = 1
}
variable "kubernetes_version" {
  default = "1.29.2"
}

# File: Modules/AKS/outputs.tf
output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}
output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
