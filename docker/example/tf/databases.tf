module "sepadd-gateway_db" {
  source            = "terraform.management.form3.tech/applications/form3_service_database/postgresql"
  version           = "0.0.1-12-g7152d68"
  database_name     = "some-database"
  app_user          = "some-database_user"
  psql_host         = var.psql_host
  psql_port         = var.psql_port
  psql_user         = var.psql_user
  psql_password     = var.psql_password
  is_local          = true
  grant_replication = true
}
