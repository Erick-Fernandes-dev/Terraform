variable "rule_name" {
  description = "Nome da regra do CloudWatch Events"
  type        = string

}

variable "sns_topic_arn" {
  description = "ARN do tópico SNS para notificações"
  type        = string
}

variable "alarm_period" {
  description = "Período de avaliação do alarme"
  type        = string
}