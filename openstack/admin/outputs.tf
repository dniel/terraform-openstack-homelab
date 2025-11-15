output "bastion" {
  value = openstack_networking_floatingip_v2.bastion.address
}

output "kubeconfig_path" {
  value = local_file.kubeconfig_file.filename
}
