locals {
  some_secret = {
    secret1 = "value2"
  }
}

resource "vault_generic_secret" "some_secret" {
  path = "secret/some_secret"
  data_json = jsonencode(local.some_secret)
}