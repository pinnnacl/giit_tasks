# Variables
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "5f926371-d8ba-4687-934a-a14019e51b51" 
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
  default     = "P@ssw0rd1234!" # Replace with a strong password
}
