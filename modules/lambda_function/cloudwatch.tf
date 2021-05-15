# Customer Master Key for CloudWatch use
data "aws_iam_policy_document" "log_cmk_policy" {
  statement {
    sid    = "AllowRoot"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatch"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    condition {
      test = "StringLike"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      ]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }

    resources = ["*"]
  }
}

resource "aws_kms_key" "log_cmk" {
  description             = "${var.environ}_${var.function_name} Logging CMK"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.log_cmk_policy.json
}

resource "aws_kms_alias" "log_cmk" {
  name          = "alias/${var.environ}_${var.function_name}/log_cmk"
  target_key_id = aws_kms_key.log_cmk.key_id
}

resource "aws_cloudwatch_log_group" "function" {
  name              = "/aws/lambda/${data.aws_region.current.name}.${var.environ}_${var.function_name}"
  retention_in_days = 30
  kms_key_id        = aws_kms_alias.log_cmk.target_key_id
}
