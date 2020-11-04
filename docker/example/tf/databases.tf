resource "postgresql_database" "my_db" {
  name              = "my_db"
  owner             = "my_role"
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
  depends_on        = [postgresql_role.my_role]
}

resource "postgresql_role" "my_role" {
  name     = "my_role"
  login    = true
  password = "mypass"
}