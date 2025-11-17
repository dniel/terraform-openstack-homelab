# Variables for vSphere connection
variable "vcenter_server" {
  type        = string
  description = "vCenter server hostname or IP address"
}

variable "vcenter_username" {
  type        = string
  description = "vCenter username"
  sensitive   = true
}

variable "vcenter_password" {
  type        = string
  description = "vCenter password"
  sensitive   = true
}

# Variables for SSH connection
variable "ssh_username" {
  type        = string
  description = "SSH username for the VM"
  sensitive   = true
}

variable "ssh_password" {
  type        = string
  description = "SSH password for the VM"
  sensitive   = true
}

# Variables for vSphere infrastructure
variable "vcenter_cluster" {
  type        = string
  description = "vCenter cluster name"
  default     = "HomeCluster"
}

variable "vcenter_datastore" {
  type        = string
  description = "vCenter datastore name"
  default     = "diskshelf-ssd"
}

variable "vcenter_network" {
  type        = string
  description = "vCenter network name"
  default     = "VLAN50_VM"
}
