provider "azurerm" {}

terraform {
  # Remote backend definition
}

resource "azurerm_resource_group" "group" {
  name        = "${var.resource_group}"
  location    = "${var.location}"
}

resource "azurerm_storage_account" "account" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.group.name}"
  location                 = "${var.location}"
  account_tier             = "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
}