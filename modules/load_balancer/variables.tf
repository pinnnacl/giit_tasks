variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "network_interface_ids" {
  type = list(string)
}

variable "ip_configuration_names" {
  type = list(string)
}