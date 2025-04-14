terraform {
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.29.0"
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

# GCP APIs
resource "google_project_service" "firestore_service" {
  service = "firestore.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "iap_service" {
  service = "iap.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "secrets_manager" {
  service = "secretmanager.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "translate_manager" {
  service = "translate.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "cloud_run" {
  service = "run.googleapis.com"
  project = var.project_id
}
resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
  project = var.project_id
}

# Firestore Database
resource "google_firestore_database" "firestore" {
  name        = "(default)"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"
}

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

# Artifact Registry
resource "google_artifact_registry_repository" "docker-registry" {
  location      = var.region
  repository_id = "${var.app_name}-registry"
  description   = "Docker repository for ${var.app_name} application"
  format        = "DOCKER"
}
