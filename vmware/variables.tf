# vSphere Provider Configuration
variable "vsphere_provider" {
  description = "vSphere provider configuration"
  type = object({
    user                 = string
    password             = string
    server               = string
    allow_unverified_ssl = bool
    api_timeout          = number
  })
  sensitive = true
  default = {
    user                 = null
    password             = null
    server               = null
    allow_unverified_ssl = true
    api_timeout          = 10
  }
}


# vSphere Infrastructure Configuration
variable "vsphere_infrastructure" {
  description = "vSphere infrastructure configuration"
  type = object({
    datacenter_name = string
    datastore_name  = string
    cluster_name    = string
    network_name    = string
  })
}

# Content Library Configuration
variable "content_library" {
  description = "Content library configuration"
  type = object({
    name      = string
    item_type = string
  })
  default = {
    name      = null
    item_type = "ovf"
  }
}

# Virtual Machine Configuration
variable "vm_config" {
  description = "Virtual machine configuration"
  type = object({
    name       = string
    num_cpus   = number
    memory     = number
    disk_label = string
    disk_size  = number
  })
  default = {
    name       = null
    num_cpus   = 1
    memory     = 1024
    disk_label = "disk0"
    disk_size  = 20
  }
}

# Authentication
variable "public_keys" {
  description = "SSH public keys for the default user"
  type        = string
  default     = ""
  sensitive   = false
}

variable "tailscale_authkey" {
  type        = string
  description = "The authentication key for Tailscale VPN service"
}
