provider "azurerm" {}

terraform {
  # Remote backend definition
}

resource "azurerm_resource_group" "group" {
  name      = "${var.resource_group}"
  location  = "${var.location}"
}

resource "azurerm_mysql_server" "server" {
  name                  = "${var.server_name}"
  location              = "${azurerm_resource_group.group.location}"
  resource_group_name   = "${azurerm_resource_group.group.name}"

  sku {
      name      = "${var.sku_name}"
      capacity  = "${var.sku_capacity}"
      tier      = "${var.sku_tier}"
      family    = "${var.sku_family}"
  }

  storage_profile {
      storage_mb            = "${var.storage_mb}"
      backup_retention_days = "${var.backup_retention_days}"
      geo_redundant_backup  = "${var.geo_redundant_backup}"
  }

  administrator_login           = "${var.admin_username}"
  administrator_login_password  = "${var.admin_password}"
  version                       = "${var.db_version}"
  ssl_enforcement               = "${var.ssl_enforcement}"
}