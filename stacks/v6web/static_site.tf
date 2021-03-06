module "v6only_site_acm" {
  source          = "../../modules/acm_cert"
  environ         = var.environ
  fqdn            = var.v6only_site_fqdn
  alternate_fqdns = ["www.${var.v6only_site_fqdn}"]
  root_zone       = var.root_zone

  # Always provision in us-east-1
  providers = {
    aws = aws.us-east-1
  }
}

module "v6only_site_redirect_lambda" {
  source              = "../../modules/lambda_function"
  environ             = "si6_${var.environ}"
  function_name       = "redirect"
  function_entrypoint = "redirect.handler"
  runtime             = "nodejs14.x"

  # Always provision in us-east-1 for Lambda@Edge use
  providers = {
    aws = aws.us-east-1
  }
}

module "v6only_site_hosting" {
  source              = "../../modules/static_site"
  acm_certificate_arn = module.v6only_site_acm.acm_cert_arn
  bucket_suffix       = "si6-${var.bucket_suffix}"
  environ             = var.environ
  fqdn                = var.v6only_site_fqdn
  log_bucket          = var.log_bucket
  redirect_lambda_arn = module.v6only_site_redirect_lambda.qualified_arn
  root_zone           = var.root_zone
  ipv6_only           = true
  # filter_lambda_arn   = module.static_site_filter_lambda.qualified_arn
}

