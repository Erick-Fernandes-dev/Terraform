variable "aws_region" {
    description = "Região da AWS"
    type = string
    default = "us-east-1"
}

variable "nome_da_funcao" {
    description = "Nome que será dado à Lambda"
    type = string
    default = "PrimeiraFuncaoModular"
  
}

variable "caminho_api" {
    description = "Endpoint da API"
    type = string
    default = "hello"
}

variable "nome_da_api" {
    description = "Nome do API Gateway"
    type = string
    default = "MinhaAPIModular"
  
}
