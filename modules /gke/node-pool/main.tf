resource "google_container_node_pool" "pw-nodepool-gke" {
 autoscaling {
  max_node_count= var.max_node_count
  min_node_count= var.min_node_count
 }
  cluster            = var.cluster_name
  location           = var.location
  project            = var.project
  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }
  max_pods_per_node = var.max_pods_per_node
  name              = var.nodepool_name
  node_config {
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    image_type      = var.image_type
    local_ssd_count = var.local_ssd_count
    machine_type    = var.machine_type
    labels          = merge(var.labels)
    oauth_scopes    = var. oauth_scopes
    service_account = var. service_account
    shielded_instance_config {
      enable_integrity_monitoring = var.enable_integrity_monitoring
      enable_secure_boot          = var.enable_secure_boot
    }
    spot = var.spot
  }
  node_count     = var.node_count
  upgrade_settings {
    max_surge       = var.max_surge
    max_unavailable = var.max_unavailable
  }
  version = var.node_version
}
