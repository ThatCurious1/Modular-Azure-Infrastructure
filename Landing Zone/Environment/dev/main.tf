module "resource_group_name" {
  source = "../../Module/Azurerm_Resource_Group"
  rgs = {
    dev = {
      name     = "dev-rg1"
      location = "central india"
    }
  }

}

module "virtual_network_name" {
  depends_on = [module.resource_group_name]
  source     = "../../Module/Azurerm_Virtual_Network"
  vnet = {
    dev = {
      name                = "dev-vnet1"
      location            = " central india"
      resource_group_name = "dev-rg1"
      address_space       = ["10.0.0.0/16"]
    }
  }

}

module "subnet_name" {
  depends_on = [module.virtual_network_name]
  source     = "../../Module/Azurerm_SubNet"
  subnet = {
    dev = {
      name                 = "dev-subnet"
      resource_group_name  = "dev-rg1"
      virtual_network_name = "dev-vnet1"
      address_prefixes     = ["10.0.1.0/24"]
    }
    dev2 = {
      name                 = "AzureBastionSubnet"
      resource_group_name  = "dev-rg1"
      virtual_network_name = "dev-vnet1"
      address_prefixes     = ["10.0.2.0/24"]
    }
  }

}

module "bastion" {
  depends_on = [module.subnet_name]
  source     = "../../Module/Azurerm_Bastion"
  pip = {
    dev = {
      name                = "dev-pip"
      location            = "central india"
      resource_group_name = "dev-rg1"
    }
  }
  bastion = {
    dev = {
      name                = "AzureBastion"
      location            = "central india"
      resource_group_name = "dev-rg1"
    }
  }
}

module "vms" {
  depends_on = [module.subnet_name]
  source     = "../../Module/Azurerm_Virtual_Machine"
  nsg = {
    dev = {
      name                = "dev-nsg"
      location            = "central india"
      resource_group_name = "dev-rg1"
    }
  }
  vm = {
    dev = {
      name                = "linuxVMAnqit"
      resource_group_name = "dev-rg1"
      location            = "central india"

    }
  }

}