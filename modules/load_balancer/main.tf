resource "azurerm_public_ip" "lb_pip" {
  name                = "nandu-tf-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  tags = {
    environment = "Production"
  }
}

resource "azurerm_lb" "lb" {
  name                = "nandu-lb"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "NanduBackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "association" {
  count                   = length(var.network_interface_ids)
  network_interface_id    = var.network_interface_ids[count.index]
  ip_configuration_name   = var.ip_configuration_names[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "ssh-running-probe"
  port            = 80
}

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend.id]
  probe_id                       = azurerm_lb_probe.probe.id
}