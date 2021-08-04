resource "aws_kms_key" "dnssec_root_zone" {
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service",
        Resource = "*"
      },
      {
        Action = "kms:CreateGrant",
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service to CreateGrant",
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Resource = "*"
        Sid      = "IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_route53_key_signing_key" "root_zone" {
  hosted_zone_id             = aws_route53_zone.root_zone.id
  key_management_service_arn = aws_kms_key.dnssec_root_zone.arn
  name                       = "${aws_route53_zone.root_zone.name}-ksk"
}

resource "aws_route53_hosted_zone_dnssec" "root_zone" {
  hosted_zone_id = aws_route53_key_signing_key.root_zone.hosted_zone_id
}

output "root_zone_key_signing_key" {
  description = "DNSSEC Key Signing Key"
  value = {
    digest_algorithm  = aws_route53_key_signing_key.root_zone.digest_algorithm_mnemonic,
    digest_value      = aws_route53_key_signing_key.root_zone.digest_value,
    signing_algorithm = aws_route53_key_signing_key.root_zone.signing_algorithm_mnemonic,
    ds_record         = aws_route53_key_signing_key.root_zone.ds_record
  }
}
