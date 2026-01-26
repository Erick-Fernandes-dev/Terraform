resource "aws_cloudwatch_metric_alarm" "event_failure" {

  alarm_name          = "alarme-${var.rule_name}-execucao"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Invocations"
  namespace           = "AWS/Events"
  period              = var.alarm_period
  statistic           = "Sum"
  threshold           = "1"

  dimensions = {
    RuleName = var.rule_name
  }

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]
}