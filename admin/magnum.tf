// create a magnum cluster template for the homelab as specified in the screenshot
resource "openstack_containerinfra_clustertemplate_v1" "homelab_template" {
  name                  = "k8s-v1.27.4"
  coe                   = "kubernetes"
  image                 = openstack_images_image_v2.ubuntu-2204-kube-v1-27-4.name
  external_network_id   = openstack_networking_network_v2.external-network.name
  dns_nameserver        = "8.8.8.8"
  flavor                = openstack_compute_flavor_v2.m2_medium.name
  master_flavor         = openstack_compute_flavor_v2.m2_medium.name
  docker_storage_driver = "overlay2"
  network_driver        = "calico"
  labels = {
    kube_tag = "v1.27.4"
  }
  public              = false
  tls_disabled        = false
  master_lb_enabled   = true
  floating_ip_enabled = true
}

// create a magnum cluster for the homelab

resource "openstack_containerinfra_cluster_v1" "homelab_cluster" {
  name                = "k8s-v1.27.4"
  cluster_template_id = "cb1c9377-4cd2-4987-ab7c-8124b756ffca"
  keypair             = data.openstack_compute_keypair_v2.mykey.name
  master_count        = 1
  node_count          = 2

  labels = {
    kube_tag = "v1.27.4"
  }
}