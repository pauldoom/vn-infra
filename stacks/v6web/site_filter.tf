# module "static_site_filter_lambda" {
#   source              = "../../modules/lambda_function"
#   environ             = var.environ
#   function_name       = "site_filter"
#   function_entrypoint = "site_filter.handler"
#   runtime             = "go1.x"
# 
#   # Always provision in us-east-1 for Lambda@Edge use
#   providers = {
#     aws = aws.us-east-1
#   }
# }
# 
