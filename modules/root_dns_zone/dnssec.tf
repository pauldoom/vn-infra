<<<<<<< Updated upstream
resource "aws_kms_key" "dnssec_root_zone" {
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
=======
locals {
  alias_prefix = replace(var.root_zone, "/\\./", "_")
  ksk_policy = jsonencode({
>>>>>>> Stashed changes
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

resource "aws_kms_key" "dnssec_root_zone" {
  for_each = var.dnssec_ksks

  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy                   = local.ksk_policy
}

resource "aws_kms_alias" "dnssec_root_zone" {
  for_each = var.dnssec_ksks

  name          = "alias/${local.alias_prefix}-ksk-${each.key}"
  target_key_id = aws_kms_key.dnssec_root_zone[each.key].key_id
}

resource "aws_route53_key_signing_key" "root_zone" {
  for_each = var.dnssec_ksks

  hosted_zone_id             = aws_route53_zone.root_zone.id
  key_management_service_arn = aws_kms_key.dnssec_root_zone[each.key].arn
  name                       = "${aws_route53_zone.root_zone.name}-ksk-${each.key}"
}

resource "aws_route53_hosted_zone_dnssec" "root_zone" {
  hosted_zone_id = aws_route53_zone.root_zone.id
}

output "root_zone_dnssec_ksks" {
  description = "DNSSEC Key Signing Key information"

  value = tomap({
    for k, v in aws_route53_key_signing_key.root_zone : k => tomap({
      digest_algorithm  = v.digest_algorithm_mnemonic,
      digest_value      = v.digest_value,
      signing_algorithm = v.signing_algorithm_mnemonic,
      ds_record         = v.ds_record
    })
  })
}
