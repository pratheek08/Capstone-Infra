variable "location" {
  default = "East US"
}

variable "vnet1_location" {
  default = "central india"
}

variable "vnet2_location" {
  default = "eastus"
}


variable "rg_name" {
  default = "modular-rg"
}

variable "vnet1_name" {
  default = "vnet-one"
}

variable "vnet2_name" {
  default = "vnet-two"
}

// variable "vnet1_address_space" {
//   default = ["10.0.0.0/16"]
// }

// variable "vnet2_address_space" {
//   default = ["10.1.0.0/16"]
// }

// variable "vnet1_subnet_names" {
//   default = ["subnet1-a", "subnet1-b", "appgw-subnet"]
// }

// variable "vnet2_subnet_names" {
//   default = ["subnet2-a", "subnet2-b", "appgw-subnet"]
// }

// variable "vnet1_subnet_prefixes" {
//   default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
// }

// variable "vnet2_subnet_prefixes" {
//   default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
// }

variable "vnet1_address_space" {
  default = ["10.0.0.0/16"]
}

variable "vnet2_address_space" {
  default = ["10.1.0.0/16"]
}

variable "vnet1_subnet_names" {
  default = ["subnet1-a", "subnet1-b"]
}

variable "vnet2_subnet_names" {
  default = ["subnet2-a", "subnet2-b"]
}

variable "vnet1_subnet_prefixes" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vnet2_subnet_prefixes" {
  default = ["10.1.1.0/24", "10.1.2.0/24"]

}

# ACR
variable "acr_name" {
  default = "mysharedacr1234"
}

# AKS
variable "node_vm_size" {
  default = "Standard_A2_v2"
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