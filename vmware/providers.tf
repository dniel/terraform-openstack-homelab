provider "vsphere" {
  user                 = var.vsphere_provider.user
  password             = var.vsphere_provider.password
  vsphere_server       = var.vsphere_provider.server
  allow_unverified_ssl = var.vsphere_provider.allow_unverified_ssl
  api_timeout          = var.vsphere_provider.api_timeout
}
