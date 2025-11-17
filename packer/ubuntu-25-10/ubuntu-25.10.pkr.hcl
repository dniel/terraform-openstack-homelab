packer {
  required_plugins {
    vsphere = {
      version = ">= 2.0.0"
      source  = "github.com/hashicorp/vsphere"
    }
    openstack = {
      source  = "github.com/hashicorp/openstack"
      version = ">= 1.0.0"
    }
  }
}

source "vsphere-iso" "yet-another-ubuntu" {
  username            = var.vcenter_username
  password            = var.vcenter_password
  vcenter_server      = var.vcenter_server
  insecure_connection = true
  cluster             = var.vcenter_cluster

  vm_name   = "yet-another-ubuntu"
  datastore = var.vcenter_datastore

  CPUs = 2
  RAM  = 4096

  disk_controller_type = ["pvscsi"]
  guest_os_type = "ubuntu64Guest"

  network_adapters {
    network      = var.vcenter_network
    network_card = "vmxnet3"
  }

  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }

  cd_label = "cidata"
  cd_content = {
    "user-data" = file("cdrom/user-data")
    "meta-data" = file("cdrom/meta-data")
  }

  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud;seed=/dev/sr1'",
    "<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]

  # packer login to vm to run cloud-init
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "20m"

  # the iso to use for the vm
  #iso_paths    = ["/isos/ubuntu-25.10-live-server-amd64/ubuntu-25.10-live-server-amd64.iso"]
  #iso_checksum = "none"

  iso_url      = "http://ftp.uninett.no/linux/ubuntu-iso/questing/ubuntu-25.10-live-server-amd64.iso"
  iso_checksum = "none"

  convert_to_template = false
  folder              = "isos"
}

# --- Build definition ---
build {
  name = "ubuntu-25-10-again-vsphere"
  sources = ["source.vsphere-iso.yet-another-ubuntu"]

  provisioner "shell" {
    execute_command = "echo 'ubuntu' | {{ .Vars }} sudo -S bash '{{ .Path }}'"
    inline = [
      "echo '--- update ubuntu ---'",
      "apt update && apt upgrade && apt autoremove",

      "echo '--- cleaning cloud-init ---'",
      "cloud-init clean --logs",
      "rm -rf /var/lib/cloud/*",

      "echo '--- cleaning machine-id ---'",
      "truncate -s 0 /etc/machine-id",
      "ln -sf /etc/machine-id /var/lib/dbus/machine-id",

      "echo '--- cleaning logs ---'",
      "rm -rf /var/log/*.log",
      "rm -rf /var/log/*/*.log",
      "rm -rf /var/log/journal/*",
      "rm -rf /var/log/installer/*",

      "echo '--- cleaning apt cache ---'",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*",

      "echo '--- cleaning login history ---'",
      "truncate -s 0 /var/log/wtmp",
      "truncate -s 0 /var/log/btmp",

      "echo '--- locking ubuntu account ---'",
      "passwd -d ubuntu",
      "passwd -l ubuntu",

      "echo '--- wipe shell history ---'",
      "rm -f /home/ubuntu/.bash_history",
      "rm -f /root/.bash_history",
      "history -c",
    ]
  }
}
