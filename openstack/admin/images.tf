resource "openstack_images_image_v2" "ubuntu-2204-kube-v1-27-4" {
  name = "ubuntu-2204-kube-v1.27.4.qcow2"

  # Already created and imported in OpenStack.
  # Only need to enable this if creating the image again.
  # image_source_url = "object-storage.public.mtl1.vexxhost.net/swift/v1/a91f106f55e64246babde7402c21b87a/magnum-capi/ubuntu-2204-kube-v1.27.4.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  image_cache_path = ""
  properties = {
    os_distro                          = "ubuntu"
    "owner_specified.openstack.md5"    = ""
    "owner_specified.openstack.object" = "images/ubuntu-2204-kube-v1.27.4.qcow2"
    "owner_specified.openstack.sha256" = ""
  }

  visibility = "shared"
}

resource "openstack_images_image_v2" "ubuntu_noble_24_04" {
  name             = "Ubuntu 24.04"
  image_source_url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  container_format = "ova"
  disk_format      = "qcow2"

  properties = {
    os_distro = "ubuntu"
  }
}

resource "openstack_images_image_v2" "cirros_0_6_2" {
  name             = "CirrOS 0.6.2"
  image_source_url = "https://download.cirros-cloud.net/0.6.2/cirros-0.6.2-x86_64-disk.img"
  container_format = "ova"
  disk_format      = "qcow2"
  properties = {
    os_distro = "cirros"
  }
}

resource "openstack_images_image_v2" "octavia_amphora_haproxy_2025_1" {
  name             = "Octavia Amphora Haproxy 2025.1"
  image_source_url = "https://swift.services.a.regiocloud.tech/swift/v1/AUTH_b182637428444b9aa302bb8d5a5a418c/openstack-octavia-amphora-image/octavia-amphora-haproxy-2025.1.qcow2"
  container_format = "ova"
  disk_format      = "qcow2"
}


resource "openstack_images_image_v2" "octavia_amphora_haproxy_2025_2" {
  name             = "Octavia Amphora Haproxy 2025.2"
  image_source_url = "https://swift.services.a.regiocloud.tech/swift/v1/AUTH_b182637428444b9aa302bb8d5a5a418c/openstack-octavia-amphora-image/octavia-amphora-haproxy-2025.2.qcow2"
  container_format = "ova"
  disk_format      = "qcow2"
}


