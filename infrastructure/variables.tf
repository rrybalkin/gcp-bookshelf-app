
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
