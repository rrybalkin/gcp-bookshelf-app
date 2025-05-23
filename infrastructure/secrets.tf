
# Secret Manager - OAuth Client Secret
resource "google_secret_manager_secret" "oauth_client_secret" {
  secret_id = "bookshelf-oauth-client-secret"

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "oauth_client_secret_version" {
  secret      = google_secret_manager_secret.oauth_client_secret.id
  secret_data = file("client_secret.json")
}

# Secret Manager - Flask Secret Key
resource "random_password" "flask_secret_key" {
  length           = var.secret_key_length
  special          = true
  override_special = true
}

resource "google_secret_manager_secret" "flask_secret_key" {
  secret_id = "flask-secret-key"

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "flask_secret_key_version" {
  secret      = google_secret_manager_secret.flask_secret_key.id
  secret_data = random_password.flask_secret_key.result
}

resource "google_secret_manager_secret" "cloudsql_user" {
  secret_id = "cloudsql-db-user"

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "cloudsql_user_version" {
  secret      = google_secret_manager_secret.cloudsql_user.id
  secret_data = var.cloudsql_db_user
}

resource "google_secret_manager_secret" "cloudsql_pass" {
  secret_id = "cloudsql-db-pass"

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "cloudsql_pass_version" {
  secret      = google_secret_manager_secret.cloudsql_pass.id
  secret_data = var.cloudsql_db_password
}
