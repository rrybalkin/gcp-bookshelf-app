
variable "project_id" {
  description = "Google Cloud project ID"
}

variable "region" {
  description = "The GCP region to deploy resources in"
  default     = "europe-north2"
}

variable "app_name" {
  description = "OAuth consent app name"
  default     = "bookshelf"
}

variable "secret_key_length" {
  description = "The length of the generated Flask secret key"
  default     = 32
  type        = number
}

variable "oauth_redirect_urls" {
  description = "The target application redirect URL to be used in OAuth consent"
  type = list(string)
}

variable "cloudsql_db_instance_tier" {
  description = "CloudSQL instance database tier to be used"
  default = "db-f1-micro"
}

variable "cloudsql_db_name" {
  description = "CloudSQL database name"
  default = "app_database"
}

variable "cloudsql_db_user" {
  description = "CloudSQL database user name"
  default = "db_admin"
}

variable "cloudsql_db_password" {
  description = "CloudSQL database user password"
  default = "admin"
}

variable "deploy_gke_cluster" {
  type = bool
  description = "Enable or disable GKE cluster deployment"
  default = true
}
