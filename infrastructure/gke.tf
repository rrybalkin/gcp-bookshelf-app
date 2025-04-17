
# Autopilot GKE Cluster Deployment
resource "google_container_cluster" "autopilot_gke" {
  name               = "${var.app_name}-gke"
  location           = var.region
  networking_mode    = "VPC_NATIVE" # Use VPC-native routing

  # Specify VPC networking
  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.vpc_subnet.id

  # Cluster configuration
  enable_autopilot                            = true
  initial_node_count                          = null # Autopilot clusters handle nodes automatically
  logging_service                             = "logging.googleapis.com/kubernetes"
  monitoring_service                          = "monitoring.googleapis.com/kubernetes"

  # Identity provider configuration to access Artifact Registry
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}
