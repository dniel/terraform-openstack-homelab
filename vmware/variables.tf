# vSphere Provider Variables
variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server address"
  type        = string
}

variable "allow_unverified_ssl" {
  description = "Allow unverified SSL certificates"
  type        = bool
  default     = true
}

variable "api_timeout" {
  description = "API timeout in minutes"
  type        = number
  default     = 10
}

# vSphere Infrastructure Variables
variable "datacenter_name" {
  description = "Name of the vSphere datacenter"
  type        = string
}

variable "datastore_name" {
  description = "Name of the vSphere datastore"
  type        = string
}

variable "cluster_name" {
  description = "Name of the vSphere compute cluster"
  type        = string
}

variable "network_name" {
  description = "Name of the vSphere network"
  type        = string
}

# Virtual Machine Variables
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_num_cpus" {
  description = "Number of CPUs for the virtual machine"
  type        = number
  default     = 1
}

variable "vm_memory" {
  description = "Memory in MB for the virtual machine"
  type        = number
  default     = 1024
}

variable "vm_guest_id" {
  description = "Guest OS identifier"
  type        = string
  default     = "otherLinux64Guest"
}

variable "vm_disk_size" {
  description = "Size of the disk in GB"
  type        = number
  default     = 20
}

variable "vm_disk_label" {
  description = "Label for the disk"
  type        = string
  default     = "disk0"
}

# Content Library Variables
variable "content_library_name" {
  description = "Name of the vSphere content library"
  type        = string
}

variable "content_library_item_name" {
  description = "Name of the item (OVA/ISO) in the content library"
  type        = string
}

variable "content_library_item_type" {
  description = "Type of the content library item (ovf, ova, iso)"
  type        = string
  default     = "ovf"
}

variable "vm_hostname" {
  description = "Hostname for the virtual machine"
  type        = string
  default     = ""
}

# vApp Properties for OVA templates
variable "guestinfo_hostname" {
  description = "Guest hostname (guestinfo.hostname)"
  type        = string
  default     = ""
  sensitive   = false
}

variable "guestinfo_ipaddress" {
  description = "Guest IP address (guestinfo.ipaddress)"
  type        = string
  default     = ""
}

variable "guestinfo_netprefix" {
  description = "Network prefix length (guestinfo.netprefix)"
  type        = string
  default     = ""
}

variable "guestinfo_gateway" {
  description = "Gateway IP address (guestinfo.gateway)"
  type        = string
  default     = ""
}

variable "guestinfo_dns" {
  description = "DNS server addresses (guestinfo.dns)"
  type        = string
  default     = ""
}

variable "guestinfo_domain" {
  description = "Domain name (guestinfo.domain)"
  type        = string
  default     = ""
}

variable "guestinfo_password" {
  description = "Root password (guestinfo.password)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "guestinfo_sshkey" {
  description = "SSH public key (guestinfo.sshkey)"
  type        = string
  default     = ""
  sensitive   = false
}

# Ubuntu Cloud-Init vApp Properties
variable "instance_id" {
  description = "A unique instance ID for this instance (instance-id)"
  type        = string
  default     = ""
}

variable "ubuntu_hostname" {
  description = "Hostname for the Ubuntu appliance"
  type        = string
  default     = ""
}

variable "seedfrom" {
  description = "URL to seed instance data from"
  type        = string
  default     = ""
}

variable "public_keys" {
  description = "SSH public keys for the default user"
  type        = string
  default     = ""
  sensitive   = false
}

variable "user_data" {
  description = "Base64 encoded user-data for cloud-init"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ubuntu_password" {
  description = "Default user's password"
  type        = string
  default     = ""
  sensitive   = true
}


variable "tailscale_authkey" {
  type        = string
  description = "The authentication key for Tailscale VPN service"
}