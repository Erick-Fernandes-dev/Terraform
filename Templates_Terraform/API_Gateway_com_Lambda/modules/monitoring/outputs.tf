output "lambda_error_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.lambda_errors.arn
}

output "api_5xx_alarm_arn" {
    value = aws_cloudwatch_metric_alarm.api_5xx_errors.arn
  
}