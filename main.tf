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
  #Use environment variable for subs_id
  subscription_id = "5f926371-d8ba-4687-934a-a14019e51b51"
}

resource "azurerm_resource_group" "nandu-tf-rg" {
  name     = "nandu-tf-rg"
  location = "East US"
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.nandu-tf-rg.name
  location            = azurerm_resource_group.nandu-tf-rg.location
}

module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = azurerm_resource_group.nandu-tf-rg.name
  location            = azurerm_resource_group.nandu-tf-rg.location
  subnet_id           = module.networking.bastion_subnet_id
}

module "vms" {
  source              = "./modules/vms"
  resource_group_name = azurerm_resource_group.nandu-tf-rg.name
  location            = azurerm_resource_group.nandu-tf-rg.location
  subnet_id           = module.networking.subnet1_id
  vm_count            = 3
}

module "load_balancer" {
  source                   = "./modules/load_balancer"
  resource_group_name      = azurerm_resource_group.nandu-tf-rg.name
  location                 = azurerm_resource_group.nandu-tf-rg.location
  network_interface_ids    = module.vms.network_interface_ids
  ip_configuration_names   = module.vms.ip_configuration_names
}