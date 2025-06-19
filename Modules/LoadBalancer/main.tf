resource "azurerm_public_ip" "this" {
  name                = "${var.name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "this" {
  name                = "${var.name}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicFrontend"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
resource "azurerm_lb_backend_address_pool" "backend" {
  name            = "${var.name}-backend-pool"
  loadbalancer_id = azurerm_lb.this.id
}

# ✅ Add Health Probe (Optional but recommended)
resource "azurerm_lb_probe" "http" {
  name                = "${var.name}-http-probe"
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
  loadbalancer_id     = azurerm_lb.this.id
}

# ✅ Add Load Balancer Rule (Assuming Ingress is exposed on NodePort)
resource "azurerm_lb_rule" "http" {
  name                           = "${var.name}-http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = var.backend_port  # default 30080 for AKS ingress
  frontend_ip_configuration_name = "PublicFrontend"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend.id
  probe_id                       = azurerm_lb_probe.http.id
  loadbalancer_id                = azurerm_lb.this.id
}


output "lb_public_ip" {
  value = azurerm_public_ip.this.ip_address
}
