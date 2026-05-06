# modules/api_gateway/main.tf

# Criação da chave de API Gateway REST API
resource "aws_api_gateway_api_key" "this" {
    name = "${var.api_name}-key"
  
}


# Criação do plano de uso para a API Gateway, que define as regras de uso e limites para os clientes que consomem a API.
resource "aws_api_gateway_usage_plan" "this" {
    name = "${var.api_name}-usage-plan"

    api_stages {
      api_id = aws_api_gateway_rest_api.this.id
      stage = aws_api_gateway_stage.stage.stage_name
    }
  
}

# Associa a chave ao plano de uso, permitindo que os clientes que possuem a 
# chave possam acessar a API de acordo com as regras definidas no plano de uso.
resource "aws_api_gateway_usage_plan_key" "this" {
    key_id = aws_api_gateway_api_key.this.id
    key_type = "API_KEY"
    usage_plan_id = aws_api_gateway_usage_plan.this.id
  
}

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

# 1. Primeiro declaramos o MÉTODO
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.res.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

# Esse resource cria um método http para o recurso criado anteriormente. Ele é configurado para aceitar 
#requisições POST e é associado ao recurso e à API criados anteriormente.
resource "aws_api_gateway_integration" "int" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.res.id
  
  # Aqui deve bater com o nome do bloco acima: "method"
  http_method = aws_api_gateway_method.method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
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

# Log group para armazenar os logs da API Gateway
resource "aws_cloudwatch_log_group" "api_logs" {
    # O nome do log gorup é definido com base no nome da API, seguindo a convenção de nomenclatura do AWS para logs de API Gateway
    name = "/aws/api-gateway/${var.api_name}"
    # Define o período de retenção dos logs em dias. Neste caso, os logs serão mantidos por 7 dias antes de serem automaticamente excluídos.
    retention_in_days = 7
  
}

# Ativa o log no stage da API Gateway, associonado o log group criado anteriormente. Isso permite que as requisições e 
# respostas da API sejam registradas no CloudWatch Logs para monitoramento e análise.
resource "aws_api_gateway_method_settings" "all" {
    # rest_api_id é o ID da API Gateway à qual as configurações de método serão aplicadas.
    rest_api_id = aws_api_gateway_rest_api.this.id
    # stage_name é o nome do estágio da API Gateway ao qual as configurações de método serão aplicadas.
    stage_name = aws_api_gateway_stage.stage.stage_name
    # method_path é o caminho do método para o qual as configurações de método serão aplicadas. 
    #Neste caso, o asterisco (*) indica que as configurações serão aplicadas a todos os métodos e recursos da API.
    method_path = "*/*"

    # settings é um bloco que define as configurações específicas para o método. Neste caso, estamos configurando o 
    # nível de log para "INFO", o que significa que as informações de log detalhadas serão registradas para as requisições e respostas 
    # da API Gateway.
    settings {
      logging_level = "INFO"
      data_trace_enabled = true # Habilita o rastreamento de dados para capturar informações detalhadas sobre as requisições e respostas da API Gateway, incluindo os payloads de entrada e saída.
      metrics_enabled = true # Habilita a coleta de métricas para a API Gateway, permitindo que você monitore o desempenho e o uso da API por meio do Amazon CloudWatch.

    }

  
}


