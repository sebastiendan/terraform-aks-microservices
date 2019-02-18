variable "resource_group" {
  description = "Resource group name"
}

variable "location" {
  description = "Location where the resource exists"
}

variable "client_id" {
  description = "Service Principal client id"
}

variable "client_secret" {
  description = "Service Principal client secret"
}

variable "k8s_version" {
  default = "1.11.5"
  description = "Number of nodes"
}

variable "agent_count" {
  description = "Number of nodes"
}

variable "vm_size" {
  default = "Standard_D1_v2"
  description = "Node VM size"
}

variable "os_type" {
  default = "Linux"
  description = "Node OS"
}

variable "os_disk_size_gb" {
  default = 30
  description = "Node OS disk size in gb"
}