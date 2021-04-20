data "aws_route53_zone" "root_zone" {
  name         = var.root_zone
  private_zone = false
}

# Main CNAME
resource "aws_route53_record" "cname_static_site" {
  name    = var.fqdn
  records = [aws_cloudfront_distribution.static_site.domain_name]
  ttl     = "300"
  type    = "CNAME"
  zone_id = data.aws_route53_zone.root_zone.zone_id
}
