# Закомментировано для проерки задания в github
#
# terraform {
#   required_providers {
#     yandex = {
#       source = "yandex-cloud/yandex"
#       version = "0.104.0"
#     }
#   }
#   required_version = ">= 0.13"
# }

resource "yandex_compute_instance" "db" {
  name = var.db_name
  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id#yandex_vpc_subnet.app-subnet.id
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/files/db_postprocessing.sh"
    ]
  }
}
