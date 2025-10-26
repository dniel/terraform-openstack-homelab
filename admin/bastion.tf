output "bastion" {
  value = openstack_networking_floatingip_v2.bastion.address
}

data "openstack_networking_network_v2" "bastion" {
  name = var.bastion.network
}

resource "openstack_networking_port_v2" "bastion" {
  name           = var.bastion.name
  network_id     = data.openstack_networking_network_v2.bastion.id
  admin_state_up = "true"
}

resource "openstack_compute_instance_v2" "bastion" {
  name            = var.bastion.name
  image_id        = var.bastion.image
  flavor_id       = var.bastion.flavor
  key_pair        = var.bastion.keypair
  security_groups = [var.bastion.security_group]

  user_data = <<-EOF
              #!/bin/bash
              curl -fsSL https://tailscale.com/install.sh | sh
              /usr/bin/tailscale up --ssh --advertise-tags=tag:bastion --authkey=${var.tailscale_authkey}

              # get bootstrap scripts...
              git clone --depth 1 https://github.com/dniel/terraform-openstack-homelab
              cd terraform-openstack-homelab
              apt install make -y
              make helm kubectl clusterctl tofu
              EOF

  network {
    port = openstack_networking_port_v2.bastion.id
  }
}

data "openstack_networking_network_v2" "external" {
  name = "external-net"
}

resource "openstack_networking_floatingip_v2" "bastion" {
  pool = data.openstack_networking_network_v2.external.name
}

resource "openstack_compute_floatingip_associate_v2" "bastion" {
  floating_ip = openstack_networking_floatingip_v2.bastion.address
  instance_id = openstack_compute_instance_v2.bastion.id
}