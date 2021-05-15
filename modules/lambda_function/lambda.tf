# Processing of index.html in subfolders
# Code adapted from https://github.com/twstewart42/terraform-aws-cloudfront-s3-website-lambda-edge
# Used under Apache 2.0 license
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/../../functions/${var.function_name}.zip"
  source_dir  = "${path.module}/../../functions/${var.function_name}/"
}

resource "aws_iam_role_policy" "lambda_execution" {
  name_prefix = "lambda-execution-policy-"
  role        = aws_iam_role.lambda_execution.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_execution" {
  name_prefix        = "lambda-execution-role-"
  description        = "Managed by Terraform"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "edgelambda.amazonaws.com",
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "function" {
  description      = "Managed by Terraform"
  filename         = "${path.module}/../../functions/${var.function_name}.zip"
  function_name    = "${var.environ}_${var.function_name}"
  handler          = var.function_entrypoint
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  publish          = true
  role             = aws_iam_role.lambda_execution.arn
  runtime          = var.runtime

  depends_on = [
    aws_cloudwatch_log_group.function
  ]
}
