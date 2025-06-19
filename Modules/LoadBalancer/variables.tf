variable "aks_node_private_ips" {
  description = "Private IPs of the AKS nodes for backend pool"
  type        = list(string)
  default     = []
}

variable "vnet_id" {
  description = "VNet ID where the AKS nodes reside"
  type        = string
}

variable "backend_port" {
  description = "Port exposed by the AKS ingress NodePort"
  type        = number
  default     = 30080
}
