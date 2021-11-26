
output "cloudfront_distribution_id" {
  value = module.v6only_site_hosting.cloudfront_distribution_id
}

output "v6only_site_bucket" {
  value = module.v6only_site_hosting.static_site_bucket
}
