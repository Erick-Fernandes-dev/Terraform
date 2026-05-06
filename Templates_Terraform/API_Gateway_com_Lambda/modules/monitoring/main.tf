# module/monitoring/main.tf

# Alarme se a lambda falhar (Error > 0)
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
    alarm_name = "${var.function_name}-errors"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = "1"
    metric_name = "Errors"
    namespace = "AWS/Lambda"
    period = "60"
    statistic = "Sum"
    threshold = "0"
    alarm_description = "Alarme para monitorar erros na função Lambda"

    dimensions = {
        FunctionName = var.function_name
    }
  
}

# Alarme se a API Gateway retornar erros 5xx 
resource "aws_cloudwatch_metric_alarm" "api_5xx_errors" {
    alarm_name = "${var.api_name}-5xx-errors"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = "1"
    metric_name = "5XXError"
    namespace = "AWS/ApiGateway"
    period = "60"
    statistic = "Sum"
    threshold = "0"
    alarm_description = "Alarme para monitorar erro críticos na API Gateway"

    dimensions = {
      ApiName = var.api_name
    }
  
}