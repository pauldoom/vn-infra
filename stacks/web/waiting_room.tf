module "waiting_room_lambda" {
  source              = "../../modules/lambda_function"
  environ             = var.environ
  function_name       = "waiting_room"
  function_entrypoint = "waiting_room.handler"
  runtime             = "nodejs14.x"

  # Always provision in us-east-1 for Lambda@Edge use
  providers = {
    aws = aws.us-east-1
  }
}

