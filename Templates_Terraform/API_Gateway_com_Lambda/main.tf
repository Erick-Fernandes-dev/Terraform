provider "aws" {
    region = var.aws_region
}


# Chamada do mudulo de Lambda
module "meu_lambda" {
    source = "./modules/lambda"
    function_name = var.nome_da_funcao
}

# Chamada do mudulo de API Gateway
module "meu_api_gateway" {
    source = "./modules/api_gateway"
    api_name = var.nome_da_api
    endpoint_path = var.caminho_api
    lambda_name = module.meu_lambda.function_name
    lambda_invoke_arn = module.meu_lambda.invoke_arn
}