#################################################
#               VPC AND SUBNETS
#################################################

module "vpc" {
  source           = "terraform-google-modules/network/google"
  version          = "~> 7.5"
  project_id       = var.project_id
  network_name     = var.network_name
  routing_mode     = var.routing_mode
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
}

#################################################
#               FIREWALL
#################################################

module "firewall-config" {
  source        = "../modules/networking/firewall"

  for_each = { for config in var.firewall_configs : config.firewall_name => config }

  direction     = each.value.direction
  network       = var.network_name
  priority      = each.value.priority
  project       = var.project_id
  port          = each.value.port
  protocol      = each.value.protocol
  description   = each.value.description
  name          = each.value.firewall_name
  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
  depends_on    = [module.vpc]
}

#################################################
#               GKE CLUSTER
#################################################
     
module "gke-private" {
  source                        = "../modules/gke/gke-cluster"
  name                          = var.name
  project                       = var.project_id
  location                      = var.location
  node_locations                = var.node_locations
  initial_node_count            = var.initial_node_count
  cluster_secondary_range_name  = var.pod_secondary_range_name
  services_secondary_range_name = var.services_secondary_range_name
  network                       = var.gke_network
  subnetwork                    = var.gke_subnetwork
  master_ipv4_cidr_block        = var.master_ipv4_cidr_block
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = var.mgmt_cidr_range
          display_name = "pw-op-app-nwtwork"
        },
        {
          cidr_block   = var.cloud_build_cidr
          display_name = "Cloud build range"
       },
        {
         cidr_block  = var.openvpn_range
         display_name = "open VPN range"
       },
       {
         cidr_block = var.openvpn_server_range
         display_name = "Open vpn server range"
            }
   
   ]
 }
]
}

#################################################
#                NODE POOL
#################################################

module "nodepool" {
  source                      = "../modules/gke/node-pools"
  
  for_each = { for pool in var.nodepools : pool.nodepool_name => pool }

  cluster_name                = each.value.cluster_name
  project                     = var.project_id
  location                    = var.location
  max_node_count              = each.value.max_node_count
  min_node_count              = each.value.min_node_count
  node_count                  = each.value.node_count
  disk_size_gb                = each.value.disk_size_gb
  machine_type                = each.value.machine_type
  labels                      = each.value.labels
  max_pods_per_node           = each.value.max_pods_per_node
  service_account             = each.value.service_account
  spot                        = each.value.spot
  max_surge                   = each.value.max_surge
  max_unavailable             = each.value.max_unavailable
  nodepool_name               = each.value.nodepool_name
  depends_on                  = [module.gke-private]
}
#################################################
#               COMPUTE VM
#################################################

module "computevm" {
  source = "./../modules/computevm"

  for_each = { for config in var.vm_configs : config.vm_name => config }

  name              = each.value.vm_name
  subnetwork_project = var.project_id
  network            = var.network_name
  subnetwork         = each.value.vm_subnetwork
  zone               = each.value.vm_zone
  labels             = each.value.vm_labels
  machine_type       = each.value.vm_machine_type
  email              = each.value.vm_service_account
  scopes             = each.value.vm_scopes
  tags               = each.value.vm_tags
  size               = each.value.vm_disk_size
  image              = each.value.vm_image
  depends_on         = [module.vpc]
}

module "computevm-openvpn" {
  source = "./../modules/computevm-public"

  for_each = { for public_config in var.vm_configs_public : public_config.vm_public_name => public_config }

  name              = each.value.vm_public_name
  subnetwork_project = var.project_id
  network            = var.network_name
  subnetwork         = each.value.vm_public_subnetwork
  zone               = each.value.vm_public_zone
  labels             = each.value.vm_public_labels
  machine_type       = each.value.vm_public_machine_type
  email              = each.value.vm_public_service_account
  scopes             = each.value.vm_public_scopes
  tags               = each.value.vm_public_tags
  size               = each.value.vm_public_disk_size
  image              = each.value.vm_public_image
  can_ip_forward     = each.value.vm_public_can_ip_forward
  depends_on         = [module.vpc]
}
#################################################
#              NAT AND ROUTER
#################################################

module "router" {
    source = "../modules/networking/router"
    project_id = var.project_id
    region = var.region
    network_name = "pw-op-vpc"
    env = var.env
    use_case = "vpc"
}

module "cloudnat" {
    source = "../modules/networking/nat"
    project_id = var.project_id
    region = var.region
    router_name = var.router_name
    nat_ips = var.nat_ips
    depends_on = [module.router]
    env = var.env
    use_case = "vpc"
}

#################################################
#              CLOUD SQL
#################################################

module "postgresql" {
    source          = "../modules/cloudsql"
    ip_range_name     = var.ip_range_name
    address           = var.address
    address_type      = var.address_type
    prefix_length     = var.prefix_length
    service           = var.service
    purpose           = var.purpose
    name              = var.db_name
    region            = var.region
    project           = var.project_id
    network           = var.network_name
    database_version  = var.database_version
    activation_policy = var.activation_policy
    availability_type = var.availability_type
    retained_backups  = var.retained_backups
    retention_unit    = var.retention_unit
    binary_log_enabled = var.binary_log_enabled
    enabled            = var.enabled
   // location           = "us"
    point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
    start_time                     = var.start_time
    transaction_log_retention_days = var.transaction_log_retention_days
    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    disk_size             = var.disk_size
    disk_type             = var.disk_type
    authorized_network_name = var.authorized_network_name
    authorized_network_value = var.authorized_network_value 
    ipv4_enabled    =   var.ipv4_enabled
    private_network = var.private_network
    require_ssl     = var.require_ssl
    zone            = var.zone
    day             = var.day
    hour            = var.hour
    pricing_plan    =  var.pricing_plan
    tier            = var.tier
    user_labels     = var.user_labels
    deletion_protection  = var.deletion_protection
}

#################################################
#              CLOUD BUILD
#################################################

resource "google_project_service" "servicenetworking" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "network" {
  name                    = var.network_name_wp
  routing_mode     = var.routing_mode
  auto_create_subnetworks = false
  depends_on             = [google_project_service.servicenetworking]
}

resource "google_compute_global_address" "worker_range" {
  name          = var.address_name_wp
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = var.address_wp
  prefix_length = var.prefix_length_wp
  network       = google_compute_network.network.id
}

resource "google_service_networking_connection" "worker_pool_conn" {
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.worker_range.name]
  depends_on              = [google_project_service.servicenetworking]
}

resource "google_cloudbuild_worker_pool" "pool" {
  name     = var.worker_pool_name
  location = var.location

  worker_config {
    disk_size_gb     = var.disk_size_wp
    machine_type     = var.machine_type_wp
    no_external_ip   = var.no_external_ip
  }

  network_config {
    peered_network          = google_compute_network.network.id
    peered_network_ip_range = "/20"
  }

  depends_on = [google_service_networking_connection.worker_pool_conn]
}

resource "google_compute_ha_vpn_gateway" "ha_gateway1" {
  region  = var.location
  name    = var.ha_vpn1_name
  network = var.network_name
}

resource "google_compute_ha_vpn_gateway" "ha_gateway2" {
  region  = var.location
  name    = var.ha_vpn2_name
  network = google_compute_network.network.id
}

resource "google_compute_router" "router1" {
  name    = var.router1_name
  region  = var.location
  network = var.network_name

  bgp {
    asn = var.asn1
  }
}

resource "google_compute_router" "router2" {
  name    = var.router2_name
  region  = var.location
  network = google_compute_network.network.name

  bgp {
    advertise_mode    = "CUSTOM"
    asn = var.asn2
  }
}

resource "google_compute_vpn_tunnel" "tunnel12" {
  name                  = var.vpn_tunnel_name_12
  region                = var.location
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway1.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway2.id
  shared_secret         = "a secret message"
  router                = var.router1_name
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel21" {
  name                  = var.vpn_tunnel_name_21
  region                = var.location
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway2.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway1.id
  shared_secret         = "a secret message"
  router                = var.router2_name
  vpn_gateway_interface = 0
}

resource "google_compute_router_interface" "router1_interface1" {
  name       = var.router1-interface1_name
  router     = google_compute_router.router1.name
  region     = var.location
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel12.name
}

resource "google_compute_router_peer" "router1_peer1" {
  name                      = var.router1-peer1_name
  router                    = google_compute_router.router1.name
  region                    = var.location
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = var.asn2
  advertised_route_priority = 0
  advertise_mode            = "CUSTOM"
  advertised_ip_ranges  {
      range = var.gke_master_range
   }
  interface                 = google_compute_router_interface.router1_interface1.name
}

resource "google_compute_router_interface" "router2_interface1" {
  name       = var.router2-interface1_name
  router     = google_compute_router.router2.name
  region     = var.location
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel21.name
}

resource "google_compute_router_peer" "router2_peer1" {
  name                      = var.router2-peer1_name
  router                    = google_compute_router.router2.name
  region                    = var.location
  peer_ip_address           = "169.254.0.1"
  peer_asn                  = var.asn1
  advertised_route_priority = 0
  advertise_mode            = "CUSTOM"
  advertised_ip_ranges  {
      range = "192.168.0.0/20"
   }
  interface                 = google_compute_router_interface.router2_interface1.name
}

#################################################
#              MEMORY STORE
#################################################

module "memorystore" {
  source = "../modules/memorystore"

  for_each = { for redis in var.redis_configs : redis.name_redis => redis }
  name                             = each.value.name_redis
  project                          = var.project_id
  service                          = "servicenetworking.googleapis.com"
  display_name                     = each.value.display_name_redis
  memory_size_gb                   = each.value.memory_size_gb
  tier                             = each.value.tier_redis
  region                           = var.region
  replica_count                    = each.value.replica_count
  read_replicas_mode               = each.value.read_replicas_mode
  authorized_network               = each.value.authorized_network_redis
  connect_mode                     = each.value.connect_mode
  auth_enabled                     = each.value.auth_enabled
  redis_version                    = each.value.redis_version
  name_network                     = var.network_name
  name_private                     = each.value.name_private
#  address                          = each.value.address_redis
  purpose                          = each.value.purpose_redis
  address_type                     = each.value.address_type_redis
  prefix_length                    = each.value.prefix_length_redis
  }

#################################################
#              LOAD BALANCER
#################################################
module "load-balancer-neg" {

  source               = "../modules/loadbalancer"
  project_id           =  var.project_id
  health_check_name    =  "rust-health-check"
  backend_services       = var.backend_services
  target_proxies       = var.target_proxies
  forwarding_rules     = var.forwarding_rules
  
}


module "load-balaner-gcs" {

  source              = "../modules/lb-gcs"
  internet_neg_name   = "m3-demo-addressables"
  gcs_backend_name    = "gcs-backend-lb"
  project_id          = var.project_id
  custom_request_headers = ["host:m3-demo-addressables.storage.googleapis.com"]


}

#####################################################
#################################################
#              GCS BUCKET
#################################################

module "gcs" {
 
  for_each = { for gcs in var.bucket_configs : gcs.gcs_name => gcs }

  gcs_name                    = each.value.gcs_name
  source                      = "../modules/gcs-bucket"
  project_id                  = var.project_id
  location                    = var.region
  versioning                  = each.value.versioning
  storage_class               = each.value.storage_class
  #autoclass                  = each.value.autoclass
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  public_access_prevention    = each.value.public_access_prevention
  force_destroy               = each.value.force_destroy


}
