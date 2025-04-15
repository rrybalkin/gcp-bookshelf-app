
# Firestore Database
resource "google_firestore_database" "firestore" {
  name        = "(default)"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"
}

# Create CloudSQL PostgreSQL instance (private + public IP)
resource "google_sql_database_instance" "cloud_sql_instance" {
  name   = "${var.app_name}-cloud-sql-instance"
  database_version = "POSTGRES_13"
  region = var.region
  settings {
    tier = var.cloudsql_db_instance_tier
    activation_policy = "ALWAYS"

    ip_configuration {
      ipv4_enabled = true  # Enable public IP
      private_network = google_compute_network.vpc_network.self_link # Attach private IP to VPC
    }
  }
}

# Create a PostgreSQL database inside CloudSQL instance
resource "google_sql_database" "app_db" {
  instance  = google_sql_database_instance.cloud_sql_instance.name
  name      = var.cloudsql_db_name
  collation = "en_US.UTF8"
}

#  Create a PostgreSQL user
resource "google_sql_user" "sql_user" {
  instance = google_sql_database_instance.cloud_sql_instance.name
  name     = var.cloudsql_db_user
  password = var.cloudsql_db_password
}
