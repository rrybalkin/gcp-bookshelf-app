
locals {
  app_sa_roles = toset([
    "roles/secretmanager.secretAccessor", "roles/cloudtranslate.user", "roles/datastore.user",
    "roles/storage.objectUser", "roles/cloudsql.instanceUser", "roles/cloudsql.client",
    "roles/iam.serviceAccountTokenCreator"
  ])
  cloudbuild_sa_roles = toset([
    "roles/cloudsql.client", "roles/artifactregistry.writer", "roles/storage.admin",
    "roles/run.admin", "roles/run.viewer", "roles/iam.serviceAccountUser",
    "roles/secretmanager.secretAccessor", "roles/logging.logWriter",
    "roles/container.clusterViewer", "roles/container.admin", "roles/compute.viewer"
  ])
}

# Service account for Application
resource "google_service_account" "app_sa" {
  account_id   = "${var.app_name}-sa"
  display_name = "App Service Account"
  description = "Application service account to access GCP services"
}

# Assign required roles to the Application service account
resource "google_project_iam_member" "app_sa_role" {
  for_each = local.app_sa_roles
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# Service account for CloudBuild pipeline
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cloud-build-sa"
  display_name = "CloudBuild Service Account"
  description = "Service Account for Cloud Build Triggers"
}

# Assign required roles to GCP CloudBuild service account
resource "google_project_iam_member" "gcp_cloudbuild_sa_role" {
  for_each = local.cloudbuild_sa_roles
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

# Assign required roles to a custom CloudBuild service account
resource "google_project_iam_member" "custom_cloudbuild_sa_role" {
  for_each = local.cloudbuild_sa_roles
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Allow k8s service to assume GCP SA
resource "google_service_account_iam_member" "k8s_sa_dev_workload_identity" {
  service_account_id = google_service_account.app_sa.id
  role    = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.project_id}.svc.id.goog[dev/${var.app_name}-app-sa]"
  depends_on = [google_container_cluster.autopilot_gke]
}
resource "google_service_account_iam_member" "k8s_sa_localdev_workload_identity" {
  service_account_id = google_service_account.app_sa.id
  role    = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.project_id}.svc.id.goog[local-dev/${var.app_name}-app-sa]"
  depends_on = [google_container_cluster.autopilot_gke]
}
