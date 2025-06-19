variable "name" {
  description = "Name prefix for the Load Balancer and resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group where the LB will be created"
  type        = string
}
