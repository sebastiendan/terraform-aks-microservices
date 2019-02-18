variable "resource_group" {
  description = "Resource group name"
}

variable "location" {
  description = "Location where the resource exists"
}

variable "services" {
  type = "list"
}
variable db_admin_username {
  type = "string"
}

variable db_admin_password {
  type = "string"
}