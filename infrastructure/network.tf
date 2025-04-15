
# Create a custom VPC
resource "google_compute_network" "vpc_network" {
  name = "${var.app_name}-vpc"
}

# Create Subnet in VPC
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${var.app_name}-subnet"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.0.0/16" # CIDR range for subnet
  region        = var.region
}

# Reserve Private IP Range for CloudSQL
resource "google_compute_global_address" "cloudsql_private_ip_address" {
  name          = "private-address-cloud-sql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16 # Private block allocation size
  network       = google_compute_network.vpc_network.self_link
}

resource "google_service_networking_connection" "private_ip_connection" {
  network            = google_compute_network.vpc_network.self_link
  service            = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloudsql_private_ip_address.name]
}
