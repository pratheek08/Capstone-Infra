variable "name" {
  description = "Prefix name for resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "backend_port" {
  description = "Port that Load Balancer forwards traffic to (e.g., NodePort 30080)"
  type        = number
  default     = 30080
}
