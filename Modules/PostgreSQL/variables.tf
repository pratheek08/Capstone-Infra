variable "postgresql_server_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "postgres_version" {
  default = "13"
}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}
variable "sku_name" {
  default = "GP_Gen5_2"
}
variable "storage_mb" {
  default = 32768
}
variable "database_name" {}
