terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  backend "remote" {
    organization = "pedidoaberto"

    workspaces {
      name = "pedidoaberto_writedatabase"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.myregion
}


# RDS
resource "aws_db_instance" "pedidoaberto_writedb" {
  identifier             = "${var.app_name}-${var.microservice_name}"
  instance_class         = var.db_instancetype
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  username               = var.db_username
  password               = data.aws_secretsmanager_random_password.pedidoaberto_writedb_password.random_password
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_secretsmanager_secret" "pedidoaberto_writedb_password_secret" {
  name = "pedidoaberto_writedb_password_secret"
  description = "Armazena senha para ser usada com o banco de dados Postgres"
}

resource "aws_secretsmanager_secret_version" "pedidoaberto_writedb_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.pedidoaberto_writedb_password_secret.id
  secret_string = data.aws_secretsmanager_random_password.pedidoaberto_writedb_password.random_password
}

data "aws_secretsmanager_random_password" "pedidoaberto_writedb_password" {
  password_length = 50
  exclude_punctuation = true
}

resource "aws_ssm_parameter" "pedidoaberto_writedb_connectionstring" {
  name  = "pedidoaberto_writedb_connectionstring"
  type  = "SecureString"
  type  = "String"
  value = "${var.db_engine}://${var.db_username}:${data.aws_secretsmanager_random_password.pedidoaberto_writedb_password.random_password}@${aws_db_instance.pedidoaberto_writedb.endpoint}/${var.db_engine}"
}