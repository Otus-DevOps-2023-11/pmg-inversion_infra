# нужен дл проверки дз
# работать может и без него
#
terraform {
  # Закомментировано для проерки задания в github
  #
  # required_providers {
  #   yandex = {
  #     source = "yandex-cloud/yandex"
  #     #   version = "0.104.0"
  #     version = ">= 0.35.0"
  #   }
  # }
  # required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    # variables not allowed here
    # see backend.conf
    # run:
    # terraform init --backend-config=backend.conf

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
  zone                     = var.zone
}
