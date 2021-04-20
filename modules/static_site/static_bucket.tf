resource "aws_s3_bucket" "static_bucket" {
  bucket = "${var.environ}-static-${var.bucket_suffix}"

  logging {
    target_bucket = var.log_bucket
    target_prefix = "/${var.environ}/s3-access-logs/static_bucket/"
  }

  website {
    index_document = "index.html"
  }

  policy = data.aws_iam_policy_document.static_bucket_policy.json

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  # TODO - Make refresh required?  Dead person's switch...
  # lifecycle_rule {
  #   prefix  = "/"
  #   enabled = true

  #   noncurrent_version_expiration {
  #     days = 30
  #   }
  #}

  # Not currently needed - Placeholder
  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["GET"]
  #   allowed_origins = ["https://*.${var.root_domain}"]
  #   expose_headers  = ["ETag"]
  # }
}

data "aws_iam_policy_document" "static_bucket_policy" {
  # Allow CloudFront OAI to access items
  statement {
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
    resources = [
      "arn:aws:s3:::${var.environ}-static-${var.bucket_suffix}/*"
    ]
  }
}
