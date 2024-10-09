#################################################
#               VPC AND SUBNETS
#################################################

variable "org" {}
variable "region" {}
variable "region_code" {}
variable "env" {}
variable "project_id" {}
variable "network_name" {}
variable "routing_mode" {}
variable "subnets" {
  description = "List of subnets to create."
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string

  }))
}

variable "secondary_ranges" {
  description = "Map of secondary ranges for subnets."
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
}

#################################################
#               FIREWALL
#################################################

variable "firewall_configs" {
  type    = list(object({

    direction   = string
    priority    = string 
    port        = list(string)
    protocol    = string
    description = string
    firewall_name        = string 
    source_ranges      = list(string) 
    target_tags = list(string) 
}))
}

#################################################
#                VM
#################################################

variable "vm_configs" {
  type    = list(object({
    vm_name           = string
    vm_subnetwork     = string
    vm_zone           = string
    vm_labels         = map(string)
    vm_machine_type   = string
    vm_service_account = string
    vm_scopes         = list(string)
    vm_tags           = list(string)
    vm_disk_size      = number
    vm_image          = string
  }))
}

variable "vm_configs_public" {
  type    = list(object({
    vm_public_name           = string
    vm_public_subnetwork     = string
    vm_public_zone           = string
    vm_public_labels         = map(string)
    vm_public_machine_type   = string
    vm_public_service_account = string
    vm_public_scopes         = list(string)
    vm_public_tags           = list(string)
    vm_public_disk_size      = number
    vm_public_image          = string
    vm_public_can_ip_forward = string
  }))
}
#################################################
#               GKE_CLUSTER
#################################################

variable "name" {}
variable "location" {}
variable "node_locations" {}
variable "initial_node_count" {}
variable "gke_network" {}
variable "gke_subnetwork" {}
variable "mgmt_cidr_range" {}
variable "cloud_build_cidr" {}
variable "pod_secondary_range_name" {}
variable "services_secondary_range_name" {}
variable "master_ipv4_cidr_block" {}
variable "openvpn_range" {}
variable "openvpn_server_range" {}
#################################################
#               GKE_NODE_POOL
#################################################

variable "nodepools" {
  type    = list(object({
    cluster_name          = string
    max_node_count        = number
    min_node_count        = number
    node_count            = number
    disk_size_gb          = number
    machine_type          = string
    labels                = map(string)
    max_pods_per_node     = number
    service_account       = string
    spot                  = bool
    max_surge             = number
    max_unavailable       = number
    nodepool_name         = string
  }))
}

#################################################
#               NAT AND ROUTER
#################################################

variable "router_name" {}
variable "nat_ips" {}

#################################################
#               CLOUD SQL
#################################################

variable "ip_range_name" {
  description = "Name of the ip rangeof service connection"
  type        = string
}
variable "db_name" {
  description = "Name of the instance"
  type        = string
}
variable "database_version" {
  description = "version of the database"
  type        = string
}
variable "activation_policy" {
  description = "This specifies when the instance should be active. Can be either ALWAYS, NEVER or ON_DEMAND"
  type        = string
}
variable "availability_type" {
  description = "The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL)"
  type        = string
}
variable "retained_backups" {
    description = "Number of backups to retain"
    type        = number
}
variable "retention_unit" {
    description = "The unit that 'retainedBackups' represents. Defaults to COUNT"
    type        = string
}
variable "binary_log_enabled" {
    description = "True if binary logging is enabled. If settings.backup_configuration.enabled is false, this must be as well"
    type        = bool
}
variable "enabled" {
    description = "True if backup configuration is enabled"
    type        = bool
}
/*variable "location" {
    description = "Location of the backup configuration"
    type        = string
}*/
variable "point_in_time_recovery_enabled" {
    description = "True if Point-in-time recovery is enabled"
    type        = bool
}
variable "start_time" {
  description = "HH:MM format time indicating when backup configuration starts"
  type        = string
}
variable "transaction_log_retention_days" {
  description = "The number of days of transaction logs we retain for point in time restore, from 1-7"
  type        = number
}
variable "disk_autoresize" {
  description = "Configuration to increase storage size automatically"
  type        = bool
}
variable "disk_autoresize_limit" {
  description = "configuration to resize the disk"
  type        = number
}
variable "disk_size" {
  description = "The size of data disk, in GB"
  type        = string
}
variable "disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD"
  type        = string
}
variable "ipv4_enabled" {
  description = "Whether this Cloud SQL instance should be assigned a public IPV4 address"
  type        = bool
}
variable "zone" {
  description = "The preferred compute engine zone"
  type        = string
}
variable "day" {
  description = "Day of week (1-7), starting on Monday"
  type        = number
}
variable "hour" {
  description = "Hour of day (0-23), ignored if day not set"
  type        = number
}
variable "tier" {
  description = "The machine type to use"
  type        = string
}
variable "user_labels" {
  description = "A set of key/value user label pairs to assign to the instance"
  type        = map(string)
}
variable "deletion_protection" {
    description = "Used to block Terraform from deleting a SQL Instance"
    type        = bool
}
variable "require_ssl" {
  description = "Whether SSL connections over IP are enforced or not"
  type        = bool
}
variable "private_network" {
  description = "The VPC network from which the Cloud SQL instance is accessible for private IP"
  type        = string
}
variable "pricing_plan" {
  description = "Pricing plan for this instance,can only be PER_USE"
  type        = string
}
/*variable "password" {
    description = "password for the user"
    type        = string
    sensitive   = true
}*/
variable "address" {
    description = "The IP address or beginning of the address range represented by this resource"
    type        = string
}
variable "address_type" {
    description = "The type of the address to reserve- Internal or External"
    type        = string
}
variable "prefix_length" {
   description = "The prefix length of the IP range"
   type        = number
}
variable "purpose" {
    description = "The purpose of the resource- VPC_PEERING, PRIVATE_SERVICE_CONNECT"
    type        = string
}
variable "service" {
  description = "Provider peering service that is managing peering connectivity for a service provider organization"
  type        = string
}

variable "authorized_network_name" {
  description = "Name of the authorized network"
  type        = string
}
variable "authorized_network_value" {
  description = "value of the authorized network"
  type        = string
}

#################################################
#              CLOUD BUILD 
#################################################

variable "network_name_wp" {
  description = "Name of the network"
  type        = string
}
variable "address_name_wp" {
  description = "Name of the address"
  type        = string
}
variable "address_wp" {
  description = "address range"
  type        = string
}

variable "prefix_length_wp" {
  description = "prefix_length"
  type        = string
}

variable "worker_pool_name" {
  description = "Name of the worker-pool"
  type        = string
}

variable "disk_size_wp" {
  description = "disk_size_worker pool"
  type        = string
}

variable "machine_type_wp" {
  description = "machine_type_worker pool"
  type        = string
}

variable "no_external_ip" {
  description = "no_external_ip"
  default    = false
}

variable "ha_vpn1_name" {
  description = "Name of the ha_vpn"
  type        = string
}

variable "ha_vpn2_name" {
  description = "Name of the ha_vpn2"
  type        = string
}

variable "router1_name" {
  description = "Name of the router1"
  type        = string
}

variable "router2_name" {
  description = "Name of the router2"
  type        = string
}

variable "asn1" {
  description = "asn value"
  default    = 64514
}

variable "asn2" {
  description = "asn value"
  default    = 64515
}

variable "vpn_tunnel_name_12" {
  description = "Name of the vpn_tunnel_name_12"
  type        = string
}

variable "vpn_tunnel_name_21" {
  description = "Name of the vpn_tunnel_name_21"
  type        = string
}

variable "router1-interface1_name" {
  description = "Name of the router1_interface"
  type        = string
}

variable "router2-interface1_name" {
  description = "Name of the router2_interface"
  type        = string
}

variable "router1-peer1_name" {
  description = "Name of the router1_peer1"
  type        = string
}

variable "router2-peer1_name" {
  description = "Name of the router1_peer1"
  type        = string
}

variable "gke_master_range" {
  description = "Name of the router1_peer1"
  type        = string
}


#################################################
#              MEMORY STORE
#################################################

variable "redis_configs" {
  type    = list(object({
   name_redis               =string
   display_name_redis        =string
   memory_size_gb            =string
   tier_redis                =string
   replica_count             =string
   read_replicas_mode        =string
   authorized_network_redis  =string
   connect_mode              =string
   auth_enabled              =string
   redis_version             =string
   name_private              =string
#   address_redis             =string
   purpose_redis             =string
   address_type_redis        =string
   prefix_length_redis       =string
  }))
}

#################################################
#              GCS_BUCKET
#################################################

variable "bucket_configs" {
  type    = list(object({
   gcs_name                    =string
   versioning                  =string
   storage_class               =string
   uniform_bucket_level_access =string
   public_access_prevention    =string
   force_destroy               =string
  }))
}

###########################################################

variable "backend_services" {
  default = [
    {
      name                 = "pw-ops-rust",
      protocol             = "HTTP",
      neg_group            = "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/zones/us-east1-b/networkEndpointGroups/k8s1-b0165098-default-pw-casim-rust-service-9000-7f7684bd",
      balancing_mode       = "RATE",
      max_rate_per_endpoint = 100,
      security_policy      =  "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/global/securityPolicies/default-security-policy-for-backend-service-pw-ops-rust"
    },
    {
      name                 = "rust-50042",
      protocol             = "HTTP",
      neg_group            = "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/zones/us-east1-b/networkEndpointGroups/k8s1-b0165098-default-pw-casim-rust-service-50042-e2abcb73",
      balancing_mode       = "RATE",
      max_rate_per_endpoint = 99,
      security_policy      =  "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/global/securityPolicies/default-security-policy-for-backend-service-rust-50042"
    },
    {
      name                 = "rust-50051",
      protocol             = "HTTP2",
      neg_group            = "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/zones/us-east1-b/networkEndpointGroups/k8s1-b0165098-default-pw-casim-rust-service-50051-829aa6da",
      balancing_mode       = "RATE",
      max_rate_per_endpoint = 100,
      security_policy      =  "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/global/securityPolicies/default-security-policy-for-backend-service-rust-50051"
    },
    {
      name                 = "rust-50052",
      protocol             = "HTTP2",
      neg_group            = "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/zones/us-east1-b/networkEndpointGroups/k8s1-b0165098-default-pw-casim-rust-service-50052-4de3a1d5",
      balancing_mode       = "RATE",
      max_rate_per_endpoint = 98,
      security_policy      =  "https://www.googleapis.com/compute/v1/projects/gcp-poc-nonproduction/global/securityPolicies/default-security-policy-for-backend-service-rust-50052"
    },
  ]
}


variable "target_proxies" {
  type = list(object({
    name             = string
    ssl_certificates = list(string)
  }))
}

variable "forwarding_rules" {
  type = list(object({
    name                 = string
    port_range           = string
    load_balancing_scheme = string
  }))
}



variable "lb_bucket_name"  {}
variable "bucket_name" {}
variable "lb_bucket_backend_name" {}
