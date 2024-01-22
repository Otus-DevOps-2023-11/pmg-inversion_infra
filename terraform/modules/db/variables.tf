variable "public_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "db_disk_image" {
  description = "Disk image for reddit db"
}
variable "db_name" {
  description = "database name"
}
