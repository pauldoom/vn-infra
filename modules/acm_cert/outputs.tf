output "acm_cert_arn" {
    description = "ARN of ACM Certificate"
    value = aws_acm_certificate.cert.arn
}