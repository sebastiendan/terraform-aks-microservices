provider "azurerm" {}

terraform {
  # Remote backend definition
}

resource "azurerm_resource_group" "group" {
  name        = "${var.resource_group}"
  location    = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${azurerm_resource_group.group.name}-cluster"
  location            = "${azurerm_resource_group.group.location}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  dns_prefix          = "${azurerm_resource_group.group.name}"
  kubernetes_version  = "${var.k8s_version}"

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_size}"
    os_type         = "${var.os_type}"
    os_disk_size_gb = "${var.os_size}"
  }

  service_principal {
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
  }

  tags {
    Environment = "Development"
  }
}