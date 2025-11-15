resource "openstack_compute_instance_v2" "cirros_0_6_2" {
  name            = "cirros-a"
  image_id        = openstack_images_image_v2.cirros_0_6_2.id
  flavor_id       = openstack_compute_flavor_v2.m1_tiny.id

  key_pair        = data.openstack_compute_keypair_v2.mykey.name

  metadata = local.default_metadata

  network {
    uuid = openstack_networking_network_v2.homelab-network.id
  }

  network {
    uuid = openstack_networking_network_v2.private-vxlan-network.id
  }
}

resource "openstack_networking_floatingip_v2" "cirros_0_6_2_fip" {
  pool = openstack_networking_network_v2.external-network.name
}

resource "openstack_compute_floatingip_associate_v2" "cirros_0_6_2_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.cirros_0_6_2_fip.address
  instance_id = openstack_compute_instance_v2.cirros_0_6_2.id
  fixed_ip    = openstack_compute_instance_v2.cirros_0_6_2.network[0].fixed_ip_v4
}

resource "openstack_compute_instance_v2" "cirros_0_6_2_b" {
  name            = "cirros-b"
  image_id        = openstack_images_image_v2.cirros_0_6_2.id
  flavor_id       = openstack_compute_flavor_v2.m1_tiny.id

  key_pair        = data.openstack_compute_keypair_v2.mykey.name

  metadata = local.default_metadata

  network {
    uuid = openstack_networking_network_v2.homelab-network.id
  }

  network {
    uuid = openstack_networking_network_v2.private-vxlan-network.id
  }
}

resource "openstack_networking_floatingip_v2" "cirros_0_6_2_b_fip" {
  pool = openstack_networking_network_v2.external-network.name
}

resource "openstack_compute_floatingip_associate_v2" "cirros_0_6_2_b_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.cirros_0_6_2_b_fip.address
  instance_id = openstack_compute_instance_v2.cirros_0_6_2_b.id
  fixed_ip    = openstack_compute_instance_v2.cirros_0_6_2_b.network[0].fixed_ip_v4
}
