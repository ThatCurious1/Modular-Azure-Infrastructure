data "azurerm_key_vault" "keyvault" {
  name                = "pipelinekeyvaultG103"
  resource_group_name = "backend_pipeline"
}

data "azurerm_key_vault_secret" "username"{
  name         = "anqit-username"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "password"{
  name         = "anqit-password"
  key_vault_id = data.azurerm_key_vault.keyvault.id
  }

data "azurerm_subnet" "subnet" {
  name                 = "dev-subnet"
  virtual_network_name = "dev-vnet1"
  resource_group_name  = "dev-rg1"
}

resource "azurerm_network_interface" "nsgs" {
    for_each = var.nsg
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vms" {
    for_each = var.vm
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = "Standard_D2as_v5"
  admin_username      = data.azurerm_key_vault_secret.username.value
  admin_password = data.azurerm_key_vault_secret.password.value
disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nsgs[each.key].id]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
