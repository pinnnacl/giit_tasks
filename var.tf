# Variables
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "******-****-****-****-*********" 
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westus"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd1234!"
}
