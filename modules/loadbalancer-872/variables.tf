variable "rg_name" { type = string }
variable "location" { type = string }
variable "linux_nic_ids" { type = list(string) }
variable "tags" { type = map(string) }
