variable "openstack_auth_url" {
  description = "The authentication URL for OpenStack"
  type        = string
}

variable "openstack_tenant_name" {
  description = "The tenant name for OpenStack"
  type        = string
}

variable "openstack_user_name" {
  description = "The user name for OpenStack"
  type        = string
}

variable "openstack_password" {
  description = "The password for OpenStack"
  type        = string
  sensitive   = true
}

variable "openstack_region" {
  description = "The region for OpenStack"
  type        = string
}

variable "bastion" {
  description = "The Bastion config"
  type = object({
    name           = string
    image          = string
    flavor         = string
    keypair        = string
    network        = string
    security_group = string
  })
}

variable "tailscale_authkey" {
  type        = string
  description = "The authentication key for Tailscale VPN service"
}