output "cloudfront_distribution_id" {
  description = "ID of static site CloudFront Distribution"
  value       = aws_cloudfront_distribution.static_site.id
}

output "static_site_bucket" {
  description = "Name of static site bucket using S3 naming"
  value       = aws_s3_bucket.static_bucket.id
}