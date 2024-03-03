# Закомментировано для проерки задания в github
#
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.104.0"
    }
  }
  required_version = ">= 0.13"
}

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

  # Закомментировано для ansible-2
  #
  # provisioner "remote-exec" {
  #   scripts = [
  #     "${path.module}/files/db_postprocessing.sh"
  #   ]
  # }

  # provisioner "install-python" {
  #   inline = [
  #     "sudo add-apt-repository -y ppa:jblgf0/python",
  #     "sudo apt-get update",
  #     "sudo apt-get install python3.6",
  #     "alias python=python3.6"
  #     "alias python3=python3.6",
  #     "echo \"alias python=python3.6\" >> ~/.bash_aliases",
  #     "echo \"alias python3=python3.6\" >> ~/.bash_aliases"
  #   ]
  # }


# echo "alias python=python3.6
# alias python3=python3.6" > ~/.bash_aliases
# cat ~/.bash_aliases

}
