# Провайдер берётся из backend.tf - в связке с ним всегда закомментирован
#
#terraform {
#   required_providers {
#     yandex = {
#       source = "yandex-cloud/yandex"
#       version = "0.104.0"
#     }
#   }
#   required_version = ">= 0.13"
# }

# provider "yandex" {
#   cloud_id                 = var.cloud_id
#   folder_id                = var.folder_id
#   service_account_key_file = var.service_account_key_file
#   zone                     = var.zone
# }

module "app" {
  source = "../modules/app"
  public_key_path = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image = var.app_disk_image
  app_name = var.app_name
  subnet_id = var.subnet_id
  database_url = module.db.external_ip_address_db

}

module "db" {
  source = "../modules/db"
  public_key_path = var.public_key_path
  private_key_path = var.private_key_path
  db_disk_image = var.db_disk_image
  db_name = var.db_name
  subnet_id = var.subnet_id
}
