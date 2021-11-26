
output "cloudfront_distribution_id" {
  value = module.static_site_hosting.cloudfront_distribution_id
}

output "static_site_bucket" {
  value = module.static_site_hosting.static_site_bucket
}
