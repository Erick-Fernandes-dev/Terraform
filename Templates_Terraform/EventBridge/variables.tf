variable "aws_region" {
  description = "Região da AWS para deploy"
  type        = string
  default     = "us-east-1"
}

variable "admin_email" {
  description = "E-mail para receber alertas do SNS"
  type        = string
}
