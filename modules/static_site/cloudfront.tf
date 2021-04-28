# CloudFront distribution with S3 bucket OAI

# Allow running without WAF - This is staic!
# tfsec:ignore:AWS045
resource "aws_cloudfront_distribution" "static_site" {
  depends_on = [
    aws_s3_bucket.static_bucket,
  ]

  origin {
    # Using regional S3 name here per:
    #  https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html#concept_S3Origin
    domain_name = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_id   = "static-${var.environ}"
    origin_path = "/public"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  aliases         = [var.fqdn, "www.${var.fqdn}"]

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "static-${var.environ}"
    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = var.redirect_lambda_arn
      include_body = false
    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  # Allow access from anywhere
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/"
  }

  # Log to ELB log bucket to keep front end AWS logs together.
  # CloudFront logs are batched and may take over 24 hours to appear.
  logging_config {
    bucket          = "${var.log_bucket}.s3.amazonaws.com"
    include_cookies = false
    prefix          = "${var.environ}/cloudfront/"
  }

  # Serve from US/Canada/Europe CloudFront instances
  price_class = "PriceClass_100"
}
