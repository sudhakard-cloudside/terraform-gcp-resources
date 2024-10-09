terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.5.0"
    }
  }
}
resource "google_compute_firewall" "firewall-config" {
  allow {
    ports    = var.port
    protocol = var.protocol
  }
  description   = var.description
  direction     = var.direction
  name          = var.name
  network       = var.network
  priority      = var.priority
  project       = var.project
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}
