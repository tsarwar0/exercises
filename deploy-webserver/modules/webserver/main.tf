resource "azurerm_virtual_machine_extension" "this" {
  name                 = "install-webserver"
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo apt-get update && sudo apt-get install -y nginx && sudo systemctl start nginx && sudo bash -c 'echo Hello, World! > /var/www/html/index.html'"
    }
  SETTINGS
}
