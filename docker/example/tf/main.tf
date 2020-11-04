provider "postgresql" {
  host            = "postgresql"
  port            = "5432"
  username        = "postgres"
  password        = "password"
  sslmode         = "disable"
  superuser       = false
  connect_timeout = 15
}


provider "vault" {
  address = "http://vault:8200"
  token = "devToken"
}

provider "aws" {
  region = "eu-west-1"
}