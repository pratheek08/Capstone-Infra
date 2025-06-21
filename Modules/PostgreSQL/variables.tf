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
  default = "MO_Standard_E4s_v3"
}
variable "storage_mb" {
  default = 32768
}
variable "database_name" {}
// variable "postgresql_server_name" {}
// variable "resource_group_name" {}
// variable "location" {}
// variable "postgres_version" {}
// variable "admin_username" {}
// variable "admin_password" {}
// variable "sku_name" {}
// variable "storage_mb" {}
// variable "database_name" {}
// variable "subnet_id" {}
// variable "private_dns_zone_id" {}
// variable "zone" {}
// variable "key_vault_id" {}
