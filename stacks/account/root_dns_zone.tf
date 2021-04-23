module "root_dns_zone" {
  source    = "../../modules/root_dns_zone"
  region    = var.region
  root_zone = var.root_zone
}

output "root_zone_id" {
  value = module.root_dns_zone.root_zone_id
}

output "root_zone_nameservers" {
  value = module.root_dns_zone.root_zone_nameservers
}
