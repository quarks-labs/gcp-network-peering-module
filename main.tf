resource "google_compute_network_peering" "this" {
  name                                = var.name
  network                             = var.network
  peer_network                        = var.peer_network
  import_custom_routes                = try(var.import_custom_routes, false)
  export_custom_routes                = try(var.export_custom_routes, false)
  import_subnet_routes_with_public_ip = try(var.import_subnet_routes_with_public_ip, false)
  export_subnet_routes_with_public_ip = try(var.export_subnet_routes_with_public_ip, false)
}
