terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.19.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "5f926371-d8ba-4687-934a-a14019e51b51"
}

resource "azurerm_resource_group" "nandu-tf-rg" {
  name     = "nandu-tf-rg"
  location = "East US"
}

module "network" {
  source              = "./modules/network"
  prefix              = "nandu"
  location            = azurerm_resource_group.nandu-tf-rg.location
  resource_group_name = azurerm_resource_group.nandu-tf-rg.name
  address_space       = ["10.0.0.0/16"]
  bastion_subnet_cidr = "10.0.1.0/24"
  subnet1             = "10.0.2.0/24"
}

module "vm" {
  source              = "./modules/vm"
  prefix              = "nandu"
  location            = azurerm_resource_group.nandu-tf-rg.location
  resource_group_name = azurerm_resource_group.nandu-tf-rg.name
  subnet              = module.network.subnet1
  address_space       = module.network.address_space
  image_publisher     = "Canonical"
  image_offer         = "0001-com-ubuntu-server-jammy"
  image_sku           = "22_04-lts"
  image_version       = "latest"
  admin_username      = "testadmin"
  admin_password      = "Password1234!"
}