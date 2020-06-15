provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
}

module "network_security_group" {
  source                = "Azure/network-security-group/azurerm//modules/HTTP"
  resource_group_name   = azurerm_resource_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "test" {
  subnet_id                 = module.network.vnet_subnets[0]
  network_security_group_id = module.network_security_group.network_security_group_id
}

module "vm" {
  source              = "github.com/goody-h/tf-azure-vm"
  application_name    = "Terraform-Demo"
  location            = "West Europe"
  resource_group      = azurerm_resource_group.example.name
  subnet_id           = module.network.vnet_subnets[0]
  public_key_path     = "~/.ssh/id_rsa.pub"
  setup_script        = "./setup.sh"
}

output "linux_vm_public_ip" {
  value = module.vm.public_ip_address
}
