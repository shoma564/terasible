provider "libvirt" {
  uri = "qemu+ssh://shoma@172.24.20.3/system"
}

resource "libvirt_volume" "os-image" {
  count = 5
  name   = "${format("terraform-vm%02d.qcow2", count.index + 1)}"
#  source = "/home/shoma/terraform/ubuntu1new.qcow2"
  source = "https://cloud-images.ubuntu.com/releases/23.04/release-20230714/ubuntu-23.04-server-cloudimg-amd64.img"
  format = "qcow2"
}


resource "libvirt_cloudinit_disk" "cloudinit_terraform-vm" {
  count = 5
  name = "${format("terraform-vm%02d.iso", count.index + 1)}"
  pool = "default"

  user_data = <<EOF
    #cloud-config
    hostname: "${format("terraform-vm%02d.qcow2", count.index + 1)}"
    user: tmcit
    password: tmcit
    chpasswd: { expire: False }
    ssh_pwauth: True
    EOF

  network_config = <<EOF
    version: 2
    ethernets:
      ens3:
        addresses:
          - "${format("172.24.20.20%d/24", count.index + 1)}"
        gateway4: 172.24.20.254
        nameservers:
          addresses: [172.24.2.51]
    EOF
}



resource "libvirt_domain" "terraform-vm" {
  count = 5
  name = "${format("ubuntu-terraform%02d", count.index + 1)}"
  memory = 2048
  vcpu = 2

  disk { volume_id = libvirt_volume.os-image[count.index].id }
  
  cloudinit = libvirt_cloudinit_disk.cloudinit_terraform-vm[count.index].id  

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    bridge = "bridge1"
  }

  console {
    type = "pty"
    target_port = "0"
  }

  graphics {
    type = "vnc"
    listen_type = "address"
    autoport = "true"
  }
#  connection {
#    host     = "${format("172.24.20.20%d/24", count.index + 1)}"
#    user     = "tmcit"
#    password = "tmcit"
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt-get update",
#      "sudo apt-get upgrade -y"
#      ]
#  }

}


resource "null_resource" "run_ansible" {
  count = length(libvirt_domain.terraform-vm)
  
  triggers = {
    vm_id = libvirt_domain.terraform-vm[count.index].id
  }

  provisioner "local-exec" {
    command = <<COMMAND
    ./ansiblessh.sh
    ansible-playbook k3s-ansible/site.yml -i inventory/my-cluster/hosts.ini
    COMMAND
  }
}
