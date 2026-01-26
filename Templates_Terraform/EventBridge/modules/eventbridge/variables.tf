variable "rule_name" {
  description = "Nome da regra do EventBridge"
  type        = string
}

variable "schedule" {
  description = "Expressão cron para agendamento da regra"
  type        = string
}