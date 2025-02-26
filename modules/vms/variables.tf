variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_count" {
  type    = number
  default = 3  # Adding a default to ensure it’s never prompted
}