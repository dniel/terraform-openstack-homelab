locals {
  default_metadata = {
    environment = "dev"
    owner       = "team-x"
    terraform   = "true"
  }
}

data "openstack_compute_keypair_v2" "mykey" {
  name = "mykey"
}

data "openstack_compute_availability_zones_v2" "nova" {}
