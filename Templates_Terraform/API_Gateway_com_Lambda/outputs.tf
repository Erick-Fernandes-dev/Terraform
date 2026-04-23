output "endpoint_url" {
    description = "URL final para testar sua Lambda via POST"
    value = "${module.meu_api_gateway.base_url}/${var.caminho_api}"
}

output "lambda_arn" {
    description = "ARN da função Lambda criada"
    value = module.meu_lambda.invoke_arn
}