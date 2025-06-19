resource "azurerm_traffic_manager_profile" "this" {
  name                = var.profile_name
  resource_group_name = var.resource_group_name
  traffic_routing_method = "Priority"

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

resource "azurerm_traffic_manager_external_endpoint" "primary" {
  name                = "primary-endpoint"
  profile_id        = azurerm_traffic_manager_profile.this.id
  target              = var.primary_ip
  endpoint_location   = var.primary_location
  priority            = 1
}

resource "azurerm_traffic_manager_external_endpoint" "secondary" {
  name                = "secondary-endpoint"
  profile_id        = azurerm_traffic_manager_profile.this.id
  target              = var.secondary_ip
  endpoint_location   = var.secondary_location
  priority            = 2
}

output "traffic_manager_fqdn" {
  value = azurerm_traffic_manager_profile.this.fqdn
}
