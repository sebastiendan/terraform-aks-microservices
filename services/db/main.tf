resource "azurerm_resource_group" "group" {
  name      = "${var.resource_group}"
  location  = "${var.location}"
}

# The following commented lines cannot be used before Terraform 10.12!

# data "template_file" "services" {
#   count    = "${length(var.services)}"
#   template = "${map(count.index, map("name", lookup(var.services[count.index], "name"), "db", lookup(var.services[count.index], "db")))}"
# }

# data "template_file" "services_db" {
#   count    = "${length(var.services)}"
#   template = "${lookup(var.services[count.index], "db")}"
# }

# data "template_file" "mysql_dbs" {
#   template = "${matchkeys(data.template_file.services_names.*.template, data.template_file.services_db.*.template, list("mysql"))}"
# }

data "null_data_source" "services" {
  count    = "${length(var.services)}"
  inputs = {
    name = "${ lookup(var.services[count.index], "name", "") }"
    db = "${ lookup(var.services[count.index], "db", "") }"
  }
}

locals {
  mysql_dbs = "${matchkeys(data.null_data_source.services.*.outputs.name, data.null_data_source.services.*.outputs.db, list("mysql"))}"
}

resource "azurerm_mysql_database" "db" {
  count = "${length(local.mysql_dbs)}"

  name                              = "${local.mysql_dbs[count.index]}"
  resource_group_name               = "${azurerm_resource_group.group.name}"
  charset                           = "utf8"
  collation                         = "utf8_general_ci"
  server_name                       = "${var.db_host}"
}

data "null_data_source" "mysql_services" {
  count = "${length(local.mysql_dbs)}"
  inputs = {
    service = "${azurerm_mysql_database.db.*.name[count.index]}"
    db_host = "${azurerm_mysql_database.db.*.server_name[count.index]}"
    db_admin_username = "${var.DB_ADMIN_USERNAME}@${azurerm_mysql_database.db.*.server_name[count.index]}"
  }
}