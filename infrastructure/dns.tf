
# DNS Managed Zone
resource "google_dns_managed_zone" "dns-zone" {
  name        = "${var.app_name}-zone"
  dns_name    = "${var.app_name}.gcp.google.com."
  description = "A custom managed DNS zone for ${var.app_name} application"
  labels = {
    app = var.app_name
  }
}

resource "google_compute_address" "service_static_address" {
  name = "${var.app_name}-ipv4-address"
}

resource "google_dns_record_set" "service_api" {
  name = "dev.${google_dns_managed_zone.dns-zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns-zone.name
  rrdatas = [google_compute_address.service_static_address.address]
}
