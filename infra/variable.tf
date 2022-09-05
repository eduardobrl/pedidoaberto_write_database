
variable "myregion" {
  description = "AWS region for all resources."

  type    = string
  default = "sa-east-1"
}

variable "accountId" {
  description = "AWS region for all resources."
  type        = string
}

variable "microservice_name" {
  description = "AWS region for all resources."

  type = string
}

variable "app_name" {
  description = "AWS region for all resources."

  type = string
}

variable "db_engine" {
  description = "Banco de dados utilizado."
  default = "postgres"
  type = string
}

variable "db_engine_version" {
  description = "Versão do banco de dados"
  default = "14.4"
  type = string
}

variable "db_username" {
  description = "Usuario do banco de dados"
  default = "postgres"
  type = string
}

variable "db_name" {
  description = "Usuario do banco de dados"
  default = "postgres"
  type = string
}

variable "db_instancetype" {
  description = "Usuario do banco de dados"
  default = "db.t3.micro"
  type = string
}

variable "db_allocated_storage" {
  description = "Armazenamento de HD alocado para o banco de dados"
  default = 5
  type = number
}