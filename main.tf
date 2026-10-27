locals {
  common_tags = {
    Project         = "CCGC 5502 Terraform Project"
    Name            = "nashrah.mahak"
    ExpirationDate  = "2027-12-31"
    Environment     = "Learning"
  }
  location = "indiasouthcentral"
}

module "rgroup" {
  source   = "./modules/rgroup-872"
  location = local.location
  tags     = local.common_tags
}

module "network" {
  source     = "./modules/network-872"
  rg_name    = module.rgroup.rg_name
  location   = local.location
  tags       = local.common_tags
  depends_on = [module.rgroup]
}

module "common" {
  source     = "./modules/common-872"
  rg_name    = module.rgroup.rg_name
  location   = local.location
  tags       = local.common_tags
  depends_on = [module.rgroup]
}

module "vmlinux" {
  source           = "./modules/vmlinux-872"
  rg_name          = module.rgroup.rg_name
  location         = local.location
  subnet_id        = module.network.subnet_id
  sa_blob_endpoint = module.common.sa_primary_blob_endpoint
  tags             = local.common_tags
  depends_on       = [module.network, module.common]
}

module "vmwindows" {
  source           = "./modules/vmwindows-872"
  rg_name          = module.rgroup.rg_name
  location         = local.location
  subnet_id        = module.network.subnet_id
  sa_blob_endpoint = module.common.sa_primary_blob_endpoint
  tags             = local.common_tags
  depends_on       = [module.network, module.common]
}

module "datadisk" {
  source        = "./modules/datadisk-872"
  rg_name       = module.rgroup.rg_name
  location      = local.location
  linux_vm_ids  = module.vmlinux.vm_ids
  windows_vm_id = module.vmwindows.vm_id
  tags          = local.common_tags
  depends_on    = [module.vmlinux, module.vmwindows]
}

module "loadbalancer" {
  source        = "./modules/loadbalancer-872"
  rg_name       = module.rgroup.rg_name
  location      = local.location
  linux_nic_ids = module.vmlinux.nic_ids
  tags          = local.common_tags
  depends_on    = [module.vmlinux]
}

module "database" {
  source     = "./modules/database-872"
  rg_name    = module.rgroup.rg_name
  location   = local.location
  tags       = local.common_tags
  depends_on = [module.rgroup]
}
