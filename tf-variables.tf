variable "name" {
  type = string
}
variable "network" {
  type = string
}

variable "peer_network" {
  type = string
}

variable "import_custom_routes" {
  type = bool
}

variable "export_custom_routes" {
  type = bool
}
variable "import_subnet_routes_with_public_ip" {
  type = bool
}

variable "export_subnet_routes_with_public_ip" {
  type  = bool
}