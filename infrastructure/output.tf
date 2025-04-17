
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
  value = google_service_account.app_sa.name
}

output "cloudbuild_service_account_name" {
  value = google_service_account.cloudbuild_sa.name
}

output "cloud_sql_public_ip" {
  description = "Public IP of the Cloud SQL instance"
  value       = google_sql_database_instance.cloud_sql_instance.public_ip_address
}

output "cloud_sql_private_ip" {
  description = "Private IP of the Cloud SQL instance"
  value       = google_sql_database_instance.cloud_sql_instance.private_ip_address
}

output "vpc_network_name" {
  description = "Name of the created VPC"
  value       = google_compute_network.vpc_network.name
}

output "vpc_subnet_name" {
  description = "Name of the created subnet"
  value       = google_compute_subnetwork.vpc_subnet.name
}

output "app_static_address_name" {
  description = "A static IP address name"
  value = google_compute_address.service_static_address.name
}

output "app_static_address_ip" {
  description = "A static IP address value"
  value = google_compute_address.service_static_address.address
}

output "app_dns_record" {
  description = "A custom managed DNS record to access application"
  value = google_dns_record_set.service_api.name
}
