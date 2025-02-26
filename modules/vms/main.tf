resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = format("nandu-nic-%02d", count.index + 1)
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = format("ipconfig-%02d", count.index + 1)
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nandu-vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow_all_inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.main[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_virtual_machine" "web" {
  count                 = var.vm_count
  name                  = format("nandu-web%02d", count.index + 1)
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main[count.index].id]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = format("nanduosdisk-%02d", count.index + 1)
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = format("nandu-web%02d", count.index + 1)
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1234!"
    custom_data    = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
cat <<EOT > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
</head>
<body>
    <h1>Hello from nandu-web${count.index + 1}</h1>
</body>
</html>
EOT
sudo service nginx restart
EOF
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "Production"
  }
}

output "network_interface_ids" {
  value = azurerm_network_interface.main[*].id
}

output "ip_configuration_names" {
  value = [for i in range(var.vm_count) : format("ipconfig-%02d", i + 1)]
}