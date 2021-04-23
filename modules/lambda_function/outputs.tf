output "qualified_arn" {
  description = "ARN of deployed Lambda"
  value       = aws_lambda_function.function.qualified_arn
}