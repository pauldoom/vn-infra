module "static_site_acm" {
  source          = "../../modules/acm_cert"
  environ         = var.environ
  fqdn            = var.static_site_fqdn
  alternate_fqdns = ["www.${var.static_site_fqdn}"]
  root_zone       = var.root_zone

  # Always provision in us-east-1
  providers = {
    aws = aws.us-east-1
  }
}

module "static_site_redirect_lambda" {
  source              = "../../modules/lambda_function"
  environ             = var.environ
  function_name       = "redirect"
  function_entrypoint = "redirect.handler"
  runtime             = "nodejs12.x"

  # Always provision in us-east-1 for Lambda@Edge use
  providers = {
    aws = aws.us-east-1
  }
}

module "static_site_hosting" {
  source              = "../../modules/static_site"
  acm_certificate_arn = module.static_site_acm.acm_cert_arn
  bucket_suffix       = var.bucket_suffix
  environ             = var.environ
  fqdn                = var.static_site_fqdn
  log_bucket          = var.log_bucket
  redirect_lambda_arn = module.static_site_redirect_lambda.qualified_arn
  root_zone           = var.root_zone

}
