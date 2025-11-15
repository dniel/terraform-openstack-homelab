resource "openstack_networking_network_v2" "external-network" {
  name           = "external-net"
  admin_state_up = true
  external       = true
}

resource "openstack_networking_subnet_v2" "external-subnet" {
  name            = "external-subnet"
  network_id      = openstack_networking_network_v2.external-network.id
  cidr            = "10.0.30.0/24"
  ip_version      = 4
  enable_dhcp     = false

  allocation_pool {
    start = "10.0.30.100"
    end   = "10.0.30.199"
  }

  gateway_ip = "10.0.30.1"
}


resource "openstack_networking_network_v2" "homelab-network" {
  name           = "homelab-network"
  admin_state_up = true

  segments {
    network_type    = "vxlan"
    segmentation_id = 115
  }
}

resource "openstack_networking_subnet_v2" "homelab-subnet" {
  name            = "homelab-subnet"
  network_id      = openstack_networking_network_v2.homelab-network.id
  cidr            = "10.56.78.0/24"
  ip_version      = 4
  enable_dhcp     = true
  dns_nameservers = ["1.1.1.1"]

  allocation_pool {
    start = "10.56.78.100"
    end   = "10.56.78.200"
  }

  gateway_ip = "10.56.78.1"
}

resource "openstack_networking_router_v2" "homelab-router" {
  name           = "homelab-router"
  admin_state_up = true
  external_network_id = openstack_networking_network_v2.external-network.id
}


resource "openstack_networking_network_v2" "private-vxlan-network" {
  name           = "private-vxlan-network"
  admin_state_up = true

  segments {
    network_type    = "vxlan"
    segmentation_id = 116
  }
}

resource "openstack_networking_subnet_v2" "private-vxlan-subnet" {
  name            = "private-vxlan-subnet"
  network_id      = openstack_networking_network_v2.private-vxlan-network.id
  cidr            = "10.88.0.0/24"
  ip_version      = 4
  enable_dhcp     = true

  allocation_pool {
    start = "10.88.0.100"
    end   = "10.88.0.200"
  }

  gateway_ip = "10.88.0.1"
}
