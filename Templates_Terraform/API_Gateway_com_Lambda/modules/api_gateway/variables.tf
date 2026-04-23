variable "api_name" {
    description = "Nome da nossa API"
    type = string
  
}

variable "endpoint_path" {
    description = "Caminho do endpoint da API"
    type = string
  
}

variable "lambda_name" {
    description = "Nome da função Lambda"
    type = string
}

variable "lambda_invoke_arn" {
    description = "ARN da função Lambda a ser invocada pela API Gateway"
    type = string
}