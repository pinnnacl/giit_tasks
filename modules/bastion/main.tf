resource "azurerm_public_ip" "bastion_pip" {
  name                = "nandu-bastion-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  tags = {
    environment = "Production"
  }
}

resource "azurerm_bastion_host" "bastion" {
  name                = "nandu-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}