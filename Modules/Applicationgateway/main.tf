resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_application_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appGwFrontendIP"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }


  backend_address_pool {
    name = "defaultBackendPool"
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontendIP"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "defaultBackendPool"
    backend_http_settings_name = "defaultBackendSetting"
  }

  backend_http_settings {
    name                  = "defaultBackendSetting"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
  }
}
