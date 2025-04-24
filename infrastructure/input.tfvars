
project_id = "cloudx-gcp-developer-rrybalkin"
region     = "europe-north2"

secret_key_length = 32
oauth_redirect_urls = [
  "http://localhost:8080/oauth2callback",
  "https://my-app-in-gke/oauth2callback"
]

# temporarily disable GKE deployment to save costs
# enable when ready to use the application
deploy_gke_cluster = false
