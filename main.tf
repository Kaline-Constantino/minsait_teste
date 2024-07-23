# Configuração do provedor Azure
provider "azurerm" {
  features {}

  # Variáveis para autenticação na Azure
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

# Criação do grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "minsait_teste_rg"
  location = "East US"
}

# Criação da rede virtual
resource "azurerm_virtual_network" "vnet" {
  name                = "minsait_teste_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Criação da sub-rede
resource "azurerm_subnet" "subnet" {
  name                 = "minsait_teste_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Criação do endereço IP público
resource "azurerm_public_ip" "public_ip" {
  name                = "minsait_teste_public_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Criação da interface de rede
resource "azurerm_network_interface" "nic" {
  name                = "minsait_teste_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Criação da máquina virtual
resource "azurerm_virtual_machine" "vm" {
  depends_on           = [azurerm_public_ip.public_ip] # Garantir que o IP público seja criado antes da VM
  name                 = "minsait_teste_vm"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size              = "Standard_DS1_v2"

  # Configuração do perfil do sistema operacional
  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Configuração do disco do sistema operacional
  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Imagem do sistema operacional
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Criação do grupo de segurança de rede
resource "azurerm_network_security_group" "nsg" {
  name                = "minsait_teste_nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Regras de segurança para SSH
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Regras de segurança para HTTP
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associação da interface de rede com o grupo de segurança de rede
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Extensão da máquina virtual para instalar Docker
resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                 = "install-docker"
  virtual_machine_id   = azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings = <<SETTINGS
  {
      "fileUris": ["https://raw.githubusercontent.com/Kaline-Constantino/minsait_teste/main/cloud-init.sh"],
      "commandToExecute": "bash cloud-init.sh"
  }
SETTINGS
}

# Saída do endereço IP público da VM
output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
