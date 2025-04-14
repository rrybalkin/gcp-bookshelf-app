
output "firestore_database_name" {
  value = google_firestore_database.firestore.name
}

output "storage_bucket_name" {
  value = google_storage_bucket.storage_bucket.name
}

output "oauth_client_secret_name" {
  value = google_secret_manager_secret.oauth_client_secret.name
}

output "flask_secret_name" {
  value = google_secret_manager_secret.flask_secret_key.name
}

output "artifact_registry_repo_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker-registry.name}"
}

output "app_service_account_name" {
  value = google_service_account.sa.name
}
