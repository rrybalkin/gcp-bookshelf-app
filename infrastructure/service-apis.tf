
# Enable neccessary GCP APIs
resource "google_project_service" "services" {
  for_each = toset([
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "firestore.googleapis.com",
    "iap.googleapis.com",
    "secretmanager.googleapis.com",
    "translate.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
  ])
  project = var.project_id
  service = each.key
}
