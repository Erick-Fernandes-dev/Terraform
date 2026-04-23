# modules/api_gateway/main.tf

// Esse resource cria a API Gateway REST API, que é o ponto de entrada para as requisições HTTP.
//Ele recebe o nome da API como variável de entrada.
resource "aws_api_gateway_rest_api" "this" {
    name = var.api_name
  
}

# Esse resource cria um recurso (endpoint) dentro da API Gateway. Ele recebe o caminho do 
#endpoint como variável de entrada e é associado à API Criada anteriormente.
resource "aws_api_gateway_resource" "res" {
    rest_api_id = aws_api_gateway_rest_api.this.id
    parent_id = aws_api_gateway_rest_api.this.root_resource_id
    path_part = var.endpoint_path
  
}

# Esse resource cria um método http para o recurso criado anteriormente. Ele é configurado para aceitar 
#requisições POST e é associado ao recurso e à API criados anteriormente.
resource "aws_api_gateway_integration" "int" {
    rest_api_id = aws_api_gateway_rest_api.this.id
    resource_id = aws_api_gateway_resource.res.id
    http_method = aws_api_gateway_method.method.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = var.lambda_invoke_arn
  
}

# Esse resource do aws_lambda_permission é necessário para permitir que a API Gateway invoque a função Lambda. 
# Ele define uma permissão que autoriza a API Gateway a executar a função Lambda especificada. O statement_id é 
# um identificador único para essa permissão, e o source_arn restringe a permissão apenas às requisições provenientes 
#da API Gateway associada.
resource "aws_lambda_permission" "allow_api" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
  
}

# Esse resource cria um estágio para a API Gateway, que é uma versão implantada da API. Ele é associado à API criada 
#anteriormente e tem um nome de estágio definido como "dev". O estágio é necessário para que a API possa ser acessada através de uma URL.
resource "aws_api_gateway_deployment" "dev" {
    depends_on = [ aws_api_gateway_integration.int ]
    rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_stage" "stage" {
    deployment_id = aws_api_gateway_deployment.dev.id
    rest_api_id = aws_api_gateway_rest_api.this.id
    stage_name = "stage"
}



