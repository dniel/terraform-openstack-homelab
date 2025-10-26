resource "openstack_compute_flavor_v2" "amphora" {
  name  = "amphora"
  vcpus = 1
  ram   = 1024
  disk  = 5
  is_public = false
}

resource "openstack_compute_flavor_v2" "m1_tiny" {
  name  = "m1.tiny"
  vcpus = 1
  ram   = 512
  disk  = 5
  is_public = true
}

resource "openstack_compute_flavor_v2" "m2_tiny" {
  name  = "m2.tiny"
  vcpus = 2
  ram   = 512
  disk  = 5
  is_public = true
}

resource "openstack_compute_flavor_v2" "m2_small" {
  name  = "m2.small"
  vcpus = 2
  ram   = 2048
  disk  = 20
  is_public = true
}

resource "openstack_compute_flavor_v2" "m2_medium" {
  name  = "m2.medium"
  vcpus = 2
  ram   = 4096
  disk  = 20
  is_public = true
}

resource "openstack_compute_flavor_v2" "m4_large" {
  name  = "m4.large"
  vcpus = 4
  ram   = 8192
  disk  = 20
  is_public = true
}

resource "openstack_compute_flavor_v2" "m8_xlarge" {
  name  = "m8.xlarge"
  vcpus = 8
  ram   = 16384
  disk  = 20
  is_public = true
}

resource "openstack_compute_flavor_v2" "m16_xxlarge" {
  name  = "m16.xxlarge"
  vcpus = 16
  ram   = 32768
  disk  = 20
  is_public = true
}

resource "openstack_compute_flavor_v2" "m32_xxxlarge" {
  name  = "m32.xxxlarge"
  vcpus = 32
  ram   = 65536
  disk  = 20
  is_public = true
} 