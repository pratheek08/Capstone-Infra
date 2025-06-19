resource "azurerm_traffic_manager_profile" "this" {
  name                = var.profile_name
  resource_group_name = var.resource_group_name
  traffic_routing_method = "Priority"
  location            = "global"

  dns_config {
    relative_name = var.dns_name
    ttl           = 30
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_endpoint" "primary" {
  name                = "primary-endpoint"
  profile_name        = azurerm_traffic_manager_profile.this.name
  resource_group_name = var.resource_group_name
  type                = "externalEndpoints"
  target              = var.primary_ip
  endpoint_location   = var.primary_location
  priority            = 1
}

resource "azurerm_traffic_manager_endpoint" "secondary" {
  name                = "secondary-endpoint"
  profile_name        = azurerm_traffic_manager_profile.this.name
  resource_group_name = var.resource_group_name
  type                = "externalEndpoints"
  target              = var.secondary_ip
  endpoint_location   = var.secondary_location
  priority            = 2
}

output "traffic_manager_fqdn" {
  value = azurerm_traffic_manager_profile.this.fqdn
}
