locals {
  datacenter_name      = var.vsphere_infrastructure.datacenter_name
  datastore_name       = var.vsphere_infrastructure.datastore_name
  cluster_name         = var.vsphere_infrastructure.cluster_name
  network_name         = var.vsphere_infrastructure.network_name
  content_library_name = var.content_library.name
}

data "vsphere_datacenter" "datacenter" {
  name = local.datacenter_name
}

data "vsphere_datastore" "datastore" {
  name          = local.datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = local.cluster_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = local.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library" "library" {
  name = local.content_library_name
}

locals {
  content_library_item_type = var.content_library.item_type
  vm_name                   = var.vm_config.name
  vm_num_cpus               = var.vm_config.num_cpus
  vm_memory                 = var.vm_config.memory
  vm_disk_label             = var.vm_config.disk_label
  vm_disk_size              = var.vm_config.disk_size
}

data "vsphere_content_library_item" "template_ubuntu" {
  #  name       = "ubuntu-25.10-server"
  name       = "yet-another-ubuntu"
  type       = local.content_library_item_type
  library_id = data.vsphere_content_library.library.id
}

resource "vsphere_virtual_machine" "vm_bar" {
  name = "bar"

  firmware                = "efi"
  efi_secure_boot_enabled = false

  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  clone {
    template_uuid = data.vsphere_content_library_item.template_ubuntu.id
  }

  num_cpus = local.vm_num_cpus
  memory   = local.vm_memory

  wait_for_guest_ip_timeout   = 0
  wait_for_guest_net_timeout  = 0
  wait_for_guest_net_routable = false

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = local.vm_disk_label
    size             = local.vm_disk_size
    unit_number      = 0
    eagerly_scrub    = false
    thin_provisioned = true
  }
  # This is what triggers cloud-init (GuestInfo datasource)
  extra_config = {
    "guestinfo.metadata" = base64encode(jsonencode({
      "local-hostname" = local.vm_name
      "instance-id"    = "id-${local.vm_name}"
    }))
    "guestinfo.userdata" = base64encode(<<-EOF
      #cloud-config
      users:
        - default
        - name: ubuntu
          groups: [docker]
          sudo: ALL=(ALL) NOPASSWD:ALL
          ssh_authorized_keys: ${var.public_keys}

      package_update: true
      package_upgrade: true
      package_reboot_if_required: true
      
      packages:
        - make
        - git
        - neovim

      runcmd:
        - curl -fsSL https://tailscale.com/install.sh | sh
        - /usr/bin/tailscale up --ssh --advertise-tags=tag:bastion --authkey=${var.tailscale_authkey}
        - git clone --depth 1 https://github.com/dniel/terraform-openstack-homelab
        - cd /terraform-openstack-homelab/static/example
        - HOME=/home/ubuntu make tofu packer govc docker
      EOF
    )
    "guestinfo.userdata.encoding" = "base64"
  }
}
