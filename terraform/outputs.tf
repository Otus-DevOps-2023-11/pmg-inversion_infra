output "external_ip_address_app" {
  value = [for i in yandex_compute_instance.app: i.network_interface.0.nat_ip_address]
}

output "internal_ip_address_app" {
  value = [for i in yandex_compute_instance.app: i.network_interface.0.ip_address]
}

output "external_ip_address_lb" {
  value = [
    for i in yandex_lb_network_load_balancer.load-balancer.listener: i.external_address_spec.*.address[0]
  ]
}

output "internal_ip_address_lb" {
  value = yandex_lb_network_load_balancer.load-balancer.listener.*.external_address_spec[0].*.address[0]
}
