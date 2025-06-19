output "lb_public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.this.ip_address
}
