org = "pw"
env = "op"
region = "us-east1"
region_code = "use1"
project_id = "gcp-poc-nonproduction"
network_name = "pw-op-vpc"
routing_mode = "GLOBAL"
subnets = [
    {
        subnet_name           = "pw-op-app-sn"
        subnet_ip             = "10.100.0.0/24"
        subnet_region         = "us-east1"
    },
    {
        subnet_name           = "pw-op-db-sn"
        subnet_ip             = "10.100.1.0/24"
        subnet_region         = "us-east1"
    },
    {
        subnet_name               = "pw-op-mgmt-sn"
        subnet_ip                 = "10.100.2.0/24"
        subnet_region             = "us-east1"
    },
    {
        subnet_name               = "pw-op-web-sn"
        subnet_ip                 = "10.100.3.0/24"
        subnet_region             = "us-east1"
    },
    {
        subnet_name               = "pw-op-prozy-only-sn"
        subnet_ip                 = "10.37.0.0/22"
        subnet_region             = "us-east1"
        purpose                   = "REGIONAL_MANAGED_PROXY"
        role                      = "ACTIVE"
}
]
secondary_ranges = {
    pw-op-app-sn =  [
         {
            range_name    = "pw-op-app-sn-gke-pod-range"
            ip_cidr_range = "10.110.0.0/16"
        },
        {
            range_name    = "pw-op-app-sn-gke-svc-range"
            ip_cidr_range = "10.210.0.0/16"
        }

    ]

    pw-op-db-sn = [
         {
            range_name    = "pw-op-db-sn-gke-pod-ip"
            ip_cidr_range = "10.120.0.0/24"
        },
        {
            range_name    = "pw-op-db-sn-gke-svc-ip"
            ip_cidr_range = "10.221.0.0/24"
        }
    ]

    pw-op-mgmt-sn =  [
         {
            range_name    = "pw-op-mgmt-sn-gke-pod-ip"
            ip_cidr_range = "10.130.0.0/24"
        },
        {
            range_name    = "pw-op-mgnt-sn-gke-svc-ip"
            ip_cidr_range = "10.231.0.0/24"
        }
    ]

    pw-op-web-sn =  [
         {
            range_name    = "pw-op-web-sn-gke-pod-ip"
            ip_cidr_range = "10.140.0.0/24"
        },
         {
            range_name    = "pw-op-web-sn-gke-svc-ip"
            ip_cidr_range = "10.252.0.0/24"
        }
    ]
}

#################################################
#                  FIREWALL
#################################################

firewall_configs = [
  {
    direction   = "INGRESS"
    priority    = 1000
    port        = ["22","5432","80","9000","50042","50051","50052"]
    protocol    = "tcp"
    description = "base-health-check-gcp"
    firewall_name        = "fw-op-services-base-health-check-gcp"
    source_ranges      = ["209.85.204.0/22", "209.85.152.0/22", "130.211.0.0/22", "35.191.0.0/16"]
    target_tags = []
},
{
 
    direction   = "INGRESS"
    priority    = 1000
    port        = ["22","3389"]
    protocol    = "tcp"
    description = "base-iap-tunnel"
    firewall_name        = "fw-op-services-base-iap-gcp"
    source_ranges      = ["35.235.240.0/20"]
    target_tags = ["mgmt", "pw-openvpn-server"]

},
{

    direction   = "INGRESS"
    priority    = 1000
    port        = ["9000","50042","50051","50052","80"]
    protocol    = "tcp"
    description = "For load balancer"
    firewall_name        = "pw-ops-rust-lb"
    source_ranges      = ["0.0.0.0/0"]
    Destination_ranges = ["34.107.234.40"]
    target_tags = ["gke-pw-op-use1-gke-cluster-0a31326f-node"]
},
{

    direction   = "INGRESS"
    priority    = 1000
    port        = ["80","443","943","1194"]
    protocol    = "tcp"
    description = "fw-firewall-openvpn"
    firewall_name        = "fw-firewall-openvpn"
    source_ranges      = ["0.0.0.0/0"]
    target_tags = ["pw-openvpn-server"]
},
{

    direction   = "INGRESS"
    priority    = 1000
    port        = ["1194"]
    protocol    = "udp"
    description = "fw-firewall-openvpn-udp"
    firewall_name        = "fw-firewall-openvpn-udp"
    source_ranges      = ["0.0.0.0/0"]
    target_tags = ["pw-openvpn-server"]
}
]

#################################################
#                  VM
#################################################

vm_configs = [
  {
    vm_name           = "vm-pw-ops-gcp-use1-mgmt"
    vm_subnetwork     = "pw-op-mgmt-sn"
    vm_zone           = "us-east1-b"
    vm_labels         =  {env = "operation", deployed-by = "cloudside", type="on-demand"}
    vm_machine_type   = "e2-medium"
    vm_service_account = "pw-ops-gcp-app@gcp-poc-nonproduction.iam.gserviceaccount.com"
    vm_scopes         = ["cloud-platform"]
    vm_tags           = ["mgmt"]
    vm_disk_size      = "100"
    vm_image          = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20231030"
  }]
vm_configs_public = [
 {
    vm_public_name           = "pw-openvpn-server-1"
    vm_public_subnetwork     = "pw-op-mgmt-sn"
    vm_public_zone           = "us-east1-b"
    vm_public_labels         =  {env = "operations", deployed-by = "cloudside", type="on-demand"}
    vm_public_machine_type   = "n2-standard-2"
    vm_public_service_account = "pw-ops-gcp-app@gcp-poc-nonproduction.iam.gserviceaccount.com"
    vm_public_scopes         = ["cloud-platform"]
    vm_public_tags           = ["pw-openvpn-server"]
    vm_public_disk_size      = "25"
    vm_public_image          = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20231213a"
    vm_public_can_ip_forward           = "true"
}



 # {
 #   vm_name           = "vm-pw-ops-gcp-use1-jenkins"
 #   vm_subnetwork     = "pw-op-mgmt-sn"
 #   vm_zone           = "us-east1-b"
 #   vm_labels         =  {env = "operations", deployed-by = "cloudside", type="on-demand"}
 #   vm_machine_type   = "e2-custom-4-8192"
 #   vm_service_account = "pw-ops-gcp-app@gcp-poc-nonproduction.iam.gserviceaccount.com"
 #   vm_scopes         = ["cloud-platform"]
 #   vm_tags           = ["mgmt"]
 #   vm_disk_size      = "100"
 #   vm_image          = "projects/windows-cloud/global/images/windows-server-2019-dc-v20231115"
 # }
]

#################################################
#                  GKE_CLUSTER
#################################################

name                          = "pw-op-use1-gke-cluster"
location                      = "us-east1"
node_locations                = ["us-east1-b"]
initial_node_count            = 1
pod_secondary_range_name      = "pw-op-app-sn-gke-pod-range"
services_secondary_range_name = "pw-op-app-sn-gke-svc-range"
gke_network                   = "pw-op-vpc"
gke_subnetwork                = "pw-op-app-sn"
master_ipv4_cidr_block        = "172.16.0.0/28"
mgmt_cidr_range               = "10.100.2.0/24"
cloud_build_cidr              = "192.168.0.0/20"
openvpn_range                 = "172.27.240.0/20"
openvpn_server_range          = "10.100.2.21/32" 
#################################################
#               GKE_NODE_POOL
#################################################
nodepools = [
  {
    cluster_name          = "pw-op-use1-gke-cluster"
    max_node_count        = "3"
    min_node_count        = "1"
    node_count            = "2"
    disk_size_gb          = "100"
    machine_type          = "e2-standard-4"
    labels                = { env = "op", team = "devops", deployed-by = "cloudside", type = "on-demand" }
    max_pods_per_node     = "25"
    service_account       = "pw-ops-gcp-app@gcp-poc-nonproduction.iam.gserviceaccount.com"
    spot                  = false
    max_surge             = 1
    max_unavailable       = 0
    nodepool_name         = "pw-op-nodepool"
  }
]


#################################################
#               NAT AND ROUTE   
#################################################

router_name = "pw-ops-rt-use1"
nat_ips = ["pw-ops-nat-ip"]


#################################################
#               CLOUD SQL
#################################################

    ip_range_name     = "gcp-apps-managed-svc-sn"
    address           = "10.100.10.0"
    address_type      = "INTERNAL" 
    prefix_length     = "24"
    service           = "servicenetworking.googleapis.com"    
    purpose           = "VPC_PEERING"
    db_name           = "pw-op-psql-use1"
    database_version  = "POSTGRES_12"
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    retained_backups  = "7"
    retention_unit    = "COUNT"
    binary_log_enabled = "false"
    enabled            = "false"
   // location           = "us"
    point_in_time_recovery_enabled = "false"
    start_time                     = "15:00"
    transaction_log_retention_days = "7"
    disk_autoresize       = "true"
    disk_autoresize_limit = "0"
    disk_size             = "50"
    disk_type             = "PD_SSD"
    ipv4_enabled    = "false"  
    private_network = "projects/gcp-poc-nonproduction/global/networks/pw-op-vpc"
    require_ssl     = "false"
    zone            = "us-east1-b"
    authorized_network_name = "google-datastudio-network"
    authorized_network_value = "142.251.74.0/23"
    day             = "5"
    hour            = "18"
    pricing_plan    = "PER_USE" 
    tier            = "db-custom-2-4096"
    user_labels     = {env="op",team="devops",deployed-by="cloudside"}
    deletion_protection  = false

#################################################
#               CLOUD BUILD
#################################################

network_name_wp       = "pw-op-vpc-wp"
address_name_wp       = "pw-op-use1-wp"
address_wp            = "192.168.0.0"
prefix_length_wp      = "20"
worker_pool_name      = "pw-op-wp-use1"
disk_size_wp          = "100"
machine_type_wp       = "e2-medium"
no_external_ip        = false
ha_vpn1_name          = "pw-op-vpn1-use1"
ha_vpn2_name          = "pw-op-vpn2-use1"
router1_name          = "pw-op-rt1-use1"
router2_name          = "pw-op-rt2-use1"
vpn_tunnel_name_12    = "pw-op-tunnel-12"
vpn_tunnel_name_21    = "pw-op-tunnel-21"
router1-interface1_name = "pw-op-rt1-interface1"
router2-interface1_name = "pw-op-rt2-interface1"
router1-peer1_name    = "pw-op-rt1-peer1"
router2-peer1_name    = "pw-op-rt2-peer2"
gke_master_range      = "172.16.0.0/28" 

#################################################
#               MEMORY STORE
#################################################

redis_configs = [
 {
     name_redis                             = "pw-op-redis-use1-2"
     display_name_redis                     = "pw-op-redis-instance-2"
     memory_size_gb                         = 5
     tier_redis                             = "STANDARD_HA"
     replica_count                          = 1
     read_replicas_mode                     = "READ_REPLICAS_ENABLED"
     authorized_network_redis               = "pw-op-vpc"
     connect_mode                           = "DIRECT_PEERING"
     auth_enabled                           = "false"
     redis_version                          = "REDIS_6_X"
     name_private                           = "pw-op-redis-2"
     address_redis                          = "10.149.0.0"
     purpose_redis                          = "VPC_PEERING"
     address_type_redis                     = "INTERNAL"
     prefix_length_redis                    = "16"
 }
]

#################################################################################################
#                                    GCS_BUCKET
#################################################################################################

bucket_configs = [
 {
     gcs_name                    = "pw-op-tf-remote-statefile"
     #autoclass                  = "true"
     versioning                  = "true"
     storage_class               = "STANDARD"
     uniform_bucket_level_access = "true" 
     public_access_prevention    = "enforced"
     force_destroy               = "false"
},
{
     gcs_name                    = "m3-demo-addressables"
     #autoclass                  = "true"
     versioning                  = "false"
     storage_class               = "STANDARD"
     uniform_bucket_level_access = "true"
     public_access_prevention    = "inherited"
     force_destroy               = "false"
}]

#################################################################################################
#############################   pw-ops-rust-lb Load Balancer ####################################


target_proxies = [
  {
    name             = "pw-ops-rust-lb-target-proxy",
    ssl_certificates = ["rust-ssl-2"],
  },
  {
    name             = "pw-ops-rust-lb-target-proxy-2",
    ssl_certificates = ["rust-ssl-2"],
  },
  {
    name             = "pw-ops-rust-lb-target-proxy-3",
    ssl_certificates = ["rust-ssl-2"],
  },
  {
    name             = "pw-ops-rust-lb-target-proxy-5",
    ssl_certificates = ["rust-ssl-2"],
  },
]

forwarding_rules = [
  {
    name                 = "casim-rust-50042",
    port_range           = "50042",
    load_balancing_scheme = "EXTERNAL_MANAGED",
  },
  {
    name                 = "casim-rust-50051",
    port_range           = "50051",
    load_balancing_scheme = "EXTERNAL_MANAGED",
  },
   {
    name                 = "casim-rust-50052",
    port_range           = "50052",
    load_balancing_scheme = "EXTERNAL_MANAGED",
  },
   {
    name                 = "casim-rust-9000",
    port_range           = "9000",
    load_balancing_scheme = "EXTERNAL_MANAGED",
  },
]
################################################################################################################
############################   GCS backend LoadBalancer ########################################################


lb_bucket_name                 =  "gcs-loadbalancer"
bucket_name                    =  "m3-demo-addressables"
lb_bucket_backend_name         =  "gcs-backend-lb"
