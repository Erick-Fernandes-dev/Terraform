output "base_url" {
    description = "URL base da API Gateway"
    value = aws_api_gateway_stage.stage.invoke_url
  
}