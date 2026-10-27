variable "rg_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }
variable "admin_username" {
  type    = string
  default = "psqladmin"
}
variable "admin_password" {
  type    = string
  default = "P@ssw0rd123456!"
}
