terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  auth_url                      = var.openstack_auth_url
  tenant_name                   = var.openstack_tenant_name
  application_credential_id     = var.openstack_user_name
  application_credential_secret = var.openstack_password
  region                        = var.openstack_region
} 