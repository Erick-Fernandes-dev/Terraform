output "sns_topic_arn" {
  value = module.sns_alerts.topic_arn
}

output "eventbridge_rule_name" {
  value = module.eb_rule.rule_name
}