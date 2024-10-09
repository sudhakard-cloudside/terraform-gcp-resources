resource "google_redis_instance" "cache" {
  name = var.name
  project = var.project
  display_name = var.display_name
  memory_size_gb = var.memory_size_gb
  tier = var.tier
  region = var.region
  replica_count = var.replica_count
  read_replicas_mode = var.read_replicas_mode
  authorized_network               = var.authorized_network
  connect_mode                     = var.connect_mode
  auth_enabled                     = var.auth_enabled
  redis_version                    = var.redis_version
#  depends_on                       = [google_service_networking_connection.private_vpc_connection]

  /* maintenance_policy {
    weekly_maintenance_window {
      day                          = var.day
      start_time {
        hours                      = var.hours
        minutes                    = var.minutes
        seconds                    = var.seconds
        nanos                      = var.nanos
      }
    }
  }
   persistence_config {
    persistence_mode               = var.persistence_mode
    rdb_snapshot_period            = var.rdb_snapshot_period
  }
  */
}

data "google_compute_network" "network" {
  name                             = var.name_network
  project                          = var.project
}

resource "google_compute_global_address" "service_range" {
  name                             = var.name_private
#  address                          = var.address
  purpose                          = var.purpose
  address_type                     = var.address_type
  prefix_length                    = var.prefix_length
  network                          = data.google_compute_network.network.self_link
  project                          = var.project
}

/* resource "google_service_networking_connection" "private_vpc_connection" {
  network                   = data.google_compute_network.network.self_link
  service                   = var.service
#  project                 = var.project
  reserved_peering_ranges   = [google_compute_global_address.service_range.name]
}
*/
