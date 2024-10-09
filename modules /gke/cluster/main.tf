resource "google_container_cluster" "pw-gke-cluster" {
  enable_shielded_nodes       = var.enable_shielded_nodes
  remove_default_node_pool    = var.remove_default_node_pool
  initial_node_count          = var.initial_node_count
  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
  location = var.location
  logging_config {
    enable_components = var.enable_components
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }
  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  name               = var.name
  network            = var.network
  network_policy {
    enabled  = var.network_policy
  }
  node_locations  = var.node_locations
  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_global_access_config {
      enabled = var.master_global_access
    }
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }
  project = var.project
  release_channel {
    channel = var.channel
  }
  subnetwork = var.subnetwork
  workload_identity_config {
    workload_pool = var.workload_pool
  }
  min_master_version = "1.27.7-gke.1056000"
}
