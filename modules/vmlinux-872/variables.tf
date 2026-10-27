variable "rg_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "sa_blob_endpoint" { type = string }
variable "tags" { type = map(string) }
variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "admin_password" {
  type    = string
  default = "P@ssw0rd123456!"
}
