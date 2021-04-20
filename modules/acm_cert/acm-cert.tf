resource "aws_acm_certificate" "cert" {
  domain_name       = var.fqdn

  validation_method = "DNS"

  tags = {
    Environment = var.environ
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    for k, v in aws_route53_record.acm_validation : v.fqdn
  ]
}
