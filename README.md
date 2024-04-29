# GCP VPC-PEERING Terraform module

Terraform module which creates VPC-PEERING resources on GCP.

## Usage

```hcl

locals {
  name    = "quarks-labs"
  project = "quarks-labs"
  region  = "us-east1"
  peering_networks = [{
    peer_project                        = "quarks-labs"
    peer_network                        = "quarks-labs"
    import_custom_routes                = true
    export_custom_routes                = true
    import_subnet_routes_with_public_ip = true
    export_subnet_routes_with_public_ip = true
  }]
}

provider "google" {
  project = local.project
  region  = local.region
}

module "network" {
  source                  = "../.."
  name                    = lower("${local.name}")
  region                  = local.region
  project                 = local.project
  auto_create_subnetworks = true
  subnetworks = [{
    name                     = "default-01"
    region                   = "us-east1"
    ip_cidr_range            = "172.28.0.0/27"
    private_ip_google_access = false
    nat = {
      nat_ip_allocate_option             = "MANUAL_ONLY"
      source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    }
    secondary_ip_ranges = [{
      range_name    = "primary"
      ip_cidr_range = "172.1.16.0/20"
      },
      {
        range_name    = "secondary"
        ip_cidr_range = "172.1.32.0/20"
    }]
    }
  ]
}

module "google_compute_network_peering_left" {
  source = "../.."

  for_each = { for idx, peering in local.peering_networks : idx => peering }

  name         = "${local.project}-to-${each.value.peer_project}"
  network      = "projects/${local.project}/global/networks/${module.network.network_name}"
  peer_network = "projects/${each.value.peer_project}/global/networks/${each.value.peer_network}"

  import_custom_routes                = try(each.value.import_custom_routes, false)
  export_custom_routes                = try(each.value.export_custom_routes, false)

  import_subnet_routes_with_public_ip = try(each.value.import_subnet_routes_with_public_ip, false)
  export_subnet_routes_with_public_ip = try(each.value.export_subnet_routes_with_public_ip, false)

  depends_on = [
    module.network
  ]
}

module "google_compute_network_peering_right" {

  source = "../.."

  for_each = { for idx, peering in local.peering_networks : idx => peering }

  name         = "${each.value.peer_project}-to-${local.project}"
  network      = "projects/${each.value.peer_project}/global/networks/${each.value.peer_network}"
  peer_network = "projects/${local.project}/global/networks/${module.network.network_name}"

  import_custom_routes                = try(each.value.import_custom_routes, false)
  export_custom_routes                = try(each.value.export_custom_routes, false)
  import_subnet_routes_with_public_ip = try(each.value.import_subnet_routes_with_public_ip, false)
  export_subnet_routes_with_public_ip = try(each.value.import_subnet_routes_with_public_ip, false)
  depends_on = [
    module.network
  ]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network_peering.this](https://registry.terraform.io/providers/hashicorp/google/5.24.0/docs/resources/compute_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_export_custom_routes"></a> [export\_custom\_routes](#input\_export\_custom\_routes) | n/a | `bool` | n/a | yes |
| <a name="input_export_subnet_routes_with_public_ip"></a> [export\_subnet\_routes\_with\_public\_ip](#input\_export\_subnet\_routes\_with\_public\_ip) | n/a | `bool` | n/a | yes |
| <a name="input_import_custom_routes"></a> [import\_custom\_routes](#input\_import\_custom\_routes) | n/a | `bool` | n/a | yes |
| <a name="input_import_subnet_routes_with_public_ip"></a> [import\_subnet\_routes\_with\_public\_ip](#input\_import\_subnet\_routes\_with\_public\_ip) | n/a | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | n/a | `string` | n/a | yes |
| <a name="input_peer_network"></a> [peer\_network](#input\_peer\_network) | n/a | `string` | n/a | yes |

## Outputs

No outputs.