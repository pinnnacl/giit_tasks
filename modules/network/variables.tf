variable "prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "address_space" { type = list(string) }
variable "bastion_subnet_cidr" { type = string }
variable "subnet1" { type = string }