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
              #cloud-config

              package_update: true
              packages:
                - make
                - git

              write_files:
                - path: /home/ubuntu/.kube/config
                  permissions: 0600
                  defer: true
                  owner: 'ubuntu:ubuntu'
                  encoding: b64
                  content: ${base64encode(openstack_containerinfra_cluster_v1.homelab_cluster.kubeconfig.raw_config)}

              runcmd:
                - curl -fsSL https://tailscale.com/install.sh | sh
                - /usr/bin/tailscale up --ssh --advertise-tags=tag:bastion --authkey=${var.tailscale_authkey}
                - git clone --depth 1 https://github.com/dniel/terraform-openstack-homelab
                - cd terraform-openstack-homelab && HOME=/home/ubuntu make helm kubectl clusterctl tofu
              EOF

  network {
    port = openstack_networking_port_v2.bastion.id
  }
}

resource "local_file" "kubeconfig_file" {
  content  = openstack_containerinfra_cluster_v1.homelab_cluster.kubeconfig.raw_config
  filename = "kubeconfig-${openstack_containerinfra_cluster_v1.homelab_cluster.name}.yaml"
  file_permission = "0600" # Set appropriate permissions
}

output "kubeconfig_path" {
  value = local_file.kubeconfig_file.filename
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