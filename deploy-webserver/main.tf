terraform {
  required_version = "= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }
  # backend "azurerm" {
  # }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "vm" {
  source              = "./modules/vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "webserver" {
  source              = "./modules/webserver"
  vm_id               = module.vm.vm_id
  vm_name             = module.vm.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
}