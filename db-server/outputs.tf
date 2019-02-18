output "server_name" {
  description   = "The server name of the Azure database"
  value         = "${azurerm_mysql_server.server.name}"
}

output "server_fqdn" {
  description   = "Fully Qualified Domain Name of the Azure database"
  value         = "${azurerm_mysql_server.server.fqdn}"
}