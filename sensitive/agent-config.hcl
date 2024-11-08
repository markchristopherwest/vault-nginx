pid_file = "./pidfile"

log_level = "debug"

vault {
   address = "http://host.docker.internal:8200"
   tls_skip_verify = true
   renew_token = false
}

auto_auth {
  method {
    type = "token_file"

    config = {
      token_file_path = "/sensitive/.vault-token"
    }
  }
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

template {  
  contents      = "{{ with secret \"transit/export/encryption-key/my_key\" }}{{ if .Data.keys }}<html><head></head><body><h1>envelope_encryption_transit:{{ index .Data.keys \"1\" }}</h1></body></html>{{ end }}{{ end }}"
  destination = "/html/index.html"
}