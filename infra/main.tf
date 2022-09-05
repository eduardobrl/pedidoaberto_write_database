terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48.0"
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
  identifier             = "pedidoaberto_writedb"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "writedb"
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
  exclude_numbers = true
}