terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.29"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "current" {}

data "google_client_openid_userinfo" "myself" {}

# Cloud Storage Bucket
resource "google_storage_bucket" "storage_bucket" {
  name          = "${var.project_id}-covers"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "storage_bucket_reader" {
  bucket = google_storage_bucket.storage_bucket.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}

# OAuth Consent Screen
# resource "google_iap_brand" "oauth_consent_screen" {
#   application_title = var.app_name
#   support_email     = data.google_client_openid_userinfo.myself.email
# }

# OAuth 2.0 Client
# resource "google_iap_client" "oauth_client" {
#   brand        = google_iap_brand.oauth_consent_screen.name
#   display_name = var.app_name
# }

# Artifact Registry
resource "google_artifact_registry_repository" "docker-registry" {
  location      = var.region
  repository_id = "${var.app_name}-registry"
  description   = "Docker repository for ${var.app_name} application"
  format        = "DOCKER"
}
