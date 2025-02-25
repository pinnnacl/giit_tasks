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

resource "azurerm_resource_group" "rg" {
  name     = "nandu-aks-rg"
  location = "East US"
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = "nandu"
  vnet_cidr           = "10.0.0.0/16"
  aks_subnet_cidr     = "10.0.1.0/24"
  bastion_subnet_cidr = "10.0.2.0/24"
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = "nandu"
  kubernetes_version  = "1.30.9"
  node_count          = 2
  node_vm_size        = "Standard_B2s"
  subnet_id           = module.network.aks_subnet_id
  service_cidr        = "10.1.0.0/16"
  dns_service_ip      = "10.1.0.10"
  aks_nsg_id          = module.network.aks_nsg_id
}

module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network.bastion_subnet_id
  bastion_nsg_id      = module.network.bastion_nsg_id
  vm_size             = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "YourSecurePassword123!"
}

output "aks_kube_config" {
  value     = module.aks.aks_kube_config
  sensitive = true
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}