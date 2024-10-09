terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.5.0"
    }
  }
}
resource "google_compute_instance" "vm-instance" {
    boot_disk {
    initialize_params {
      image = var.image
      size = var.size
    }  
}

  can_ip_forward      = var.can_ip_forward
  deletion_protection = var.deletion_protection
  enable_display      = var.enable_display
  labels              = merge(var.labels)
  zone                = var.zone
  machine_type        = var.machine_type
  name                = var.name
  network_interface {
   // access_config {    // If we specify access config then the external IP address will be displayed otherwise not
   // }
  network            = var.network
  queue_count        = var.queue_count
  stack_type         = var.stack_type
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  }
  project            = var.subnetwork_project
  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    on_host_maintenance = var.on_host_maintenance
    min_node_cpus       = var.min_node_cpus
    automatic_restart   = var.preemptible ? "false" : "true"
    preemptible         = var.preemptible
  }
  service_account {
    email  = var.email
    scopes = var.scopes
  }
  metadata = {
  }
  tags = var.tags
}
