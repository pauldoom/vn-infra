
output "root_zone_id" {
  value = module.root_dns_zone.root_zone_id
}

output "root_zone_nameservers" {
  value = module.root_dns_zone.root_zone_nameservers
}
