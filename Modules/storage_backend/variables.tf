variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the Azure Storage Account."
}

variable "container_name" {
  type        = string
  description = "The name of the blob container for storing tfstate."
}
