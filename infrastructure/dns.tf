
# Static IP address to be used by K8s service
resource "google_compute_address" "service_static_address" {
  name = "${var.app_name}-ipv4-address"
}

resource "google_endpoints_service" "service_cloud_endpoint" {
  service_name = "${var.app_name}.endpoints.${var.project_id}.cloud.goog"
  project = var.project_id
  openapi_config = templatefile("${path.module}/resources/open-api.yaml", {
    app_name = var.app_name
    project_id = var.project_id
    ip_address = google_compute_address.service_static_address.address
  })
}
