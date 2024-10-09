resource "google_compute_global_address" "gcp-apps-managed-svc-sn" {
  address       = var.address
  address_type  = var.address_type
  name          = var.ip_range_name
  network       = var.network
  prefix_length = var.prefix_length
  project       = var.project
  purpose       = var.purpose
}
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = var.service
  //project                 = var.project
  reserved_peering_ranges = [google_compute_global_address.gcp-apps-managed-svc-sn.name]
}
resource "google_sql_database_instance" "psql-01" {
  database_version = var.database_version
  name             = var.name
  project          = var.project
  region           = var.region
  depends_on       = [google_service_networking_connection.private_vpc_connection]
  settings {
    activation_policy = var.activation_policy
    availability_type = var.availability_type
    backup_configuration {
      backup_retention_settings {
        retained_backups = var.retained_backups
        retention_unit   = var.retention_unit
      }
      binary_log_enabled             = var.binary_log_enabled
      enabled                        = var.enabled
     // location                       = var.location
      point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
      start_time                     = var.start_time
      transaction_log_retention_days = var.transaction_log_retention_days
    }
    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    disk_size             = var.disk_size
    disk_type             = var.disk_type
    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.private_network
      require_ssl     = var.require_ssl
    authorized_networks {
         name  = var.authorized_network_name 
         value = var.authorized_network_value
    }
   }
    location_preference {
      zone = var.zone
    }
    maintenance_window {
      day  = var.day
      hour = var.hour
    }
    pricing_plan = var.pricing_plan
    tier         = var.tier
    user_labels = merge(var.user_labels)
  }
   deletion_protection = var.deletion_protection
}
