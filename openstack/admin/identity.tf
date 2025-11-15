resource "openstack_identity_project_v3" "project_homelab" {
  name        = "homelab"
  description = "Homelab project for development and testing"
  enabled     = true
}

resource "openstack_identity_user_v3" "daniel" {
  name        = "daniel"
  description = "User daniel"
  enabled     = true
}

resource "openstack_identity_role_v3" "role_devops" {
  name = "role_devops"
}

resource "openstack_identity_group_v3" "group_devops" {
  name        = "group_devops"
  description = "DevOps Group"
}
