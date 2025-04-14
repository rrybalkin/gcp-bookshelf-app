
# Service account for Application
resource "google_service_account" "app_sa" {
  account_id   = "${var.app_name}-sa"
  display_name = "App Service Account"
  description = "Application service account to access GCP services"
}

# Assign roles to the service account
resource "google_project_iam_member" "secret_manager_role" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_project_iam_member" "cloud_translate_role" {
  project = var.project_id
  role    = "roles/cloudtranslate.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_project_iam_member" "datastore_role" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_project_iam_member" "storage_object_role" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# Service account for CloudBuild pipeline
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cloud-build-sa"
  display_name = "CloudBuild Service Account"
  description = "Service Account for Cloud Build Triggers"
}

# Assign required roles to GCP CloudBuild service account
resource "google_project_iam_member" "cloudbuild_repoadmin_role" {
  project = var.project_id
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_project_iam_member" "cloudbuild_storageadmin_role" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}
