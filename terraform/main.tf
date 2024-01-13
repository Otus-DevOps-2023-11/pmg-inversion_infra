# terraform {
#   required_providers {
#     yandex = {
#       source = "yandex-cloud/yandex"
#       version = "0.104.0"
#     }
#   }
#   required_version = ">= 0.13"
# }

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
  zone                     = var.zone
}

resource "yandex_compute_instance" "app" {
  count = var.app_cnt
  name  = "reddit-app-${count.index}"

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    scripts = [
      "files/clear_locks.sh",
      "files/deploy.sh"
    ]
  }
}
