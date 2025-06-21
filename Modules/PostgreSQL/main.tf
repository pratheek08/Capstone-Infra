resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.postgresql_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  sku_name               = var.sku_name
  storage_mb             = var.storage_mb
  backup_retention_days  = 7

  // delegated_subnet_id = var.subnet_id
  // private_dns_zone_id = var.private_dns_zone_id
  zone = "1"

  high_availability {
    mode                       = "ZoneRedundant"
    standby_availability_zone = "2"  # opposite of the primary zone
  }

  authentication {
    password_auth_enabled         = true
    active_directory_auth_enabled = false
  }

  tags = {
    Environment = "Dev"
  }
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "AllowAll"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

// resource "azurerm_key_vault_secret" "postgres_password" {
//   name         = "postgres-admin-password"
//   value        = var.admin_password
//   key_vault_id = var.key_vault_id
//   depends_on   = [azurerm_postgresql_flexible_server.this]
// }

