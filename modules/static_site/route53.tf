data "aws_route53_zone" "root_zone" {
  name         = var.root_zone
  private_zone = false
}

# Main
resource "aws_route53_record" "alias_static_site" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = var.fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aliasv6_static_site" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = var.fqdn
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

# WWW
resource "aws_route53_record" "alias_static_site_www" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "www.${var.fqdn}"
  type    = "CNAME"
  ttl     = "300"

  records = [var.fqdn]
}
