// output "postgresql_fqdn" {
//   value = azurerm_postgresql_flexible_server.this.fqdn
// }
// output "postgresql_server_id" {
//   value = azurerm_postgresql_flexible_server.this.id
// }
output "postgresql_server_id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}
