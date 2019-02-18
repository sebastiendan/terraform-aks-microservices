provider "kubernetes" {
  alias = "kubernetes"
}

provider "azurerm" {
  alias = "azurerm"
}

terraform {
  # Remote backend definition
}

module "storages" {
  source    = "./db"
  providers = {
    azurerm = "azurerm.azurerm"
  }
  resource_group = "${var.resource_group}"
  location = "${var.location}"
  db_host = "${var.db_host}"
  db_admin_username = "${var.db_admin_username}"
  db_admin_password = "${var.db_admin_password}"
  services = "${var.services}"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "${var.namespace}"
  }
}

resource "kubernetes_secret" "secret" {
  metadata {
    name = "docker-cfg"
    namespace = "${kubernetes_namespace.namespace.metadata.0.name}"
  }

  data {
    // You first need to docker login to your private repository
    ".dockerconfigjson" = "${file("~/.docker/config.json")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_deployment" "deployments" {
  count = "${length(var.services)}"

  metadata {
    name = "${lookup(var.services[count.index], "name")}"

    labels {
      name = "${lookup(var.services[count.index], "name")}"
    }
  }

  spec {
    replicas = "${lookup(var.services[count.index], "replicas")}"

    selector {
      match_labels {
        name = "${lookup(var.services[count.index], "name")}"
      }
    }

    template {
      metadata {
        labels {
          name = "${lookup(var.services[count.index], "name")}"
        }
      }

      spec {
        image_pull_secrets = {
          name = "docker-cfg"
        }
        container {
          image = "${lookup(var.services[count.index], "image")}:${lookup(var.services[count.index], "version")}"
          image_pull_policy = "Always" // For auto update on pod destruction => ONLY FOR DEVELOPMENT
          name  = "${lookup(var.services[count.index], "name")}"
          env = [
            {
              name = "MYSQL_DB_HOST"
              // Cannot be automatically constructed before Terraform 10.12
              value = ""
            },
            {
              name = "MYSQL_DB_ADMIN_USERNAME"
              // Cannot be automatically constructed before Terraform 10.12
              value = ""
            },
            {
              name = "MYSQL_DB_ADMIN_PASSWORD"
              value = "${var.db_admin_password}"
            },
            {
              name = "BLOB_STORAGE_ACCOUNT_NAME"
              value = "${var.blob_storage_account_name}"
            },
            {
              name = "BLOB_STORAGE_ACCOUNT_ACCESS_KEY"
              value = "${var.blob_storage_account_access_key}"
            },
          ]
          # !!!!! CANNOT USE THIS BEFORE TERRAFORM 10.12 !!!!!
          # env = [
          #   {
          #     name = "ENV"
          #     value = "${terraform.workspace}"
          #   },
          #   {
          #     name = "DB_HOST"
          #     value = "${element(matchkeys(data.null_data_source.mysql_services.outputs.*.db_host, module.storages.mysql_services.*.service, list(lookup(var.services[count.index], "name"))),0)}"
          #   },
          #   {
          #     name = "DB_ADMIN_USERNAME"
          #     value = "${element(matchkeys(module.storages.mysql_services.*.db_admin_username, module.storages.mysql_services.*.service, list(lookup(var.services[count.index], "name"))),0)}"
          #   },
          #   {
          #     name = "DB_ADMIN_PASSWORD"
          #     value = "${var.DB_ADMIN_PASSWORD}"
          #   },
          # ]
          port {
            container_port = "${lookup(var.services[count.index], "target_port")}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "services" {
  count = "${length(var.services)}"

  metadata {
    name      = "${lookup(var.services[count.index], "name")}"
    namespace = "${terraform.workspace}"
  }

  spec {
    session_affinity = "ClientIP"

    selector {
      name = "${lookup(var.services[count.index], "name")}"
    }

    port {
      name = "http"
      port        = "${lookup(var.services[count.index], "port")}"
      target_port = "${lookup(var.services[count.index], "target_port")}"
    }
  }
}