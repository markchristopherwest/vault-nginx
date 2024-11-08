terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.12.0"
    }
  }
}

provider "vault" {
  # Configuration options
  # address = "http://127.0.0.1:8200"
  # skip_tls_verify = true
  skip_child_token = true
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/transit_secret_backend_cache_config#example-usage
resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
  description               = "Example description"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/transit_secret_backend_cache_config
resource "vault_transit_secret_cache_config" "cfg" {
  backend = vault_mount.transit.path
  size    = 500
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/transit_secret_backend_key#auto_rotate_period
resource "vault_transit_secret_backend_key" "key" {
  backend            = vault_mount.transit.path
  name               = "my_key"
  deletion_allowed   = true
  auto_rotate_period = 0
  exportable = true
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/transit_encrypt
data "vault_transit_encrypt" "test" {
  backend   = vault_mount.transit.path
  key       = vault_transit_secret_backend_key.key.name
  plaintext = "foobar"
}

# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/transit_decrypt#example-usage
data "vault_transit_decrypt" "test" {
  backend    = "transit"
  key        = vault_transit_secret_backend_key.key.name
  ciphertext = data.vault_transit_encrypt.test.ciphertext
}
