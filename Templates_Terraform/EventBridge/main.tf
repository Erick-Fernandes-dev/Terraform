# Módulo para gerenciamento de notificações
module "sns_alerts" {
  source        = "./modules/sns"
  topic_name    = "alertas-infra-sre"
  email_address = var.admin_email

}

# Módulo para automação de Eventos (Ex: Backup n8n)
module "eb_rule" {
  source    = "./modules/eventbridge"
  rule_name = "backup-n8n-workflow"
  schedule  = "rate(5 minutes)"
}

# Módulo para Observabilidade e Alarmes
module "cloudwatch_alarms" {
  source        = "./modules/monitoring"
  rule_name     = module.eb_rule.rule_name
  sns_topic_arn = module.sns_alerts.topic_arn
  alarm_period  = "600"

}