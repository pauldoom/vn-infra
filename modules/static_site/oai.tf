resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "Origin Access Identity - ${var.environ} - ${var.fqdn}"
}

output "cloudfront_oai_arn" {
  value = aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn
}

output "cloudfront_oai_path" {
  value = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
}
