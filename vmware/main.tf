data "vsphere_datacenter" "datacenter" {
  name = var.datacenter_name
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library" "library" {
  name = var.content_library_name
}

data "vsphere_content_library_item" "template_ubuntu" {
  name       = "ubuntu-25.10-server"
  type       = var.content_library_item_type
  library_id = data.vsphere_content_library.library.id
}

resource "vsphere_virtual_machine" "vm_bar" {
  name             = "bar"

  firmware = "efi"
  efi_secure_boot_enabled = false

  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  clone {
    template_uuid = data.vsphere_content_library_item.template_ubuntu.id
  }

  num_cpus = var.vm_num_cpus
  memory   = var.vm_memory

  wait_for_guest_ip_timeout   = 0
  wait_for_guest_net_timeout  = 0
  wait_for_guest_net_routable = false

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = var.vm_disk_label
    size             = var.vm_disk_size
    unit_number      = 0
    eagerly_scrub    = false
    thin_provisioned = true
  }  # This is what triggers cloud-init (GuestInfo datasource)
  extra_config = {
    "guestinfo.metadata"             = base64encode(jsonencode({
      "local-hostname" = var.vm_name
      "instance-id"    = "id-${var.vm_name}"
    }))
    "guestinfo.userdata"             = base64encode(<<-EOF
      #cloud-config
      users:
        - default
        - name: ubuntu
          sudo: ALL=(ALL) NOPASSWD:ALL
          ssh_authorized_keys: ${var.public_keys}
          
      package_update: true
      packages:
        - make
        - git

      runcmd:
        - curl -fsSL https://tailscale.com/install.sh | sh
        - /usr/bin/tailscale up --ssh --advertise-tags=tag:bastion --authkey=${var.tailscale_authkey}
        - git clone --depth 1 https://github.com/dniel/terraform-openstack-homelab
        - cd terraform-openstack-homelab && HOME=/home/ubuntu make tofu
      EOF
    )
    "guestinfo.userdata.encoding"    = "base64"
  }
}