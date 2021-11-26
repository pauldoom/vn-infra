data "aws_route53_zone" "root_zone" {
  name         = var.root_zone
  private_zone = false
}

resource "aws_route53_record" "static_site_main_a" {
  count   = var.ipv6_only == true ? 0 : 1
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = var.fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "static_site_www_a" {
  count   = var.ipv6_only == true ? 0 : 1
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "www.${var.fqdn}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "static_site_main_aaaa" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = var.fqdn
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "static_site_www_aaaa" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "www.${var.fqdn}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}
