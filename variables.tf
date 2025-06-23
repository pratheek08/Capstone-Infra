variable "location" {
  default = "Japan West"
}

variable "vnet1_location" {
  default = "Australia Central"
}

variable "vnet2_location" {
  default = "japanwest"
}

variable "rg_name" {
  default = "pratheekRGcapstone"
}

variable "vnet1_name" {
  default = "pratheekVnet-1"
}

variable "vnet2_name" {
  default = "pratheekVnet-2"
}

variable "vnet1_address_space" {
  default = ["10.0.0.0/16"]
}

variable "vnet2_address_space" {
  default = ["10.1.0.0/16"]
}

variable "vnet1_subnet_names" {
  default = ["pratheeksubnet1-a", "pratheeksubnet1-b"]
}

variable "vnet2_subnet_names" {
  default = ["pratheeksubnet2-a", "pratheeksubnet2-b"]
}

variable "vnet1_subnet_prefixes" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vnet2_subnet_prefixes" {
  default = ["10.1.1.0/24", "10.1.2.0/24"]

}

# ACR
variable "acr_name" {
  default = "PratheekACRcapstone"
}

# AKS
variable "node_vm_size1" {
  default = "Standard_D2s_v3"
}
variable "node_vm_size2" {
  default = "Standard_D2s_v3"
}
variable "default_node_count" {
  default = 1
}
variable "additional_node_count" {
  default = 1
}
variable "kubernetes_version" {
  default = "1.29.15"
}