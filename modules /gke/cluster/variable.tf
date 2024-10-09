variable "project" {}
variable "location" {}
variable "name" {
  description = "Name of the cluster"
  type        = string
}
variable "node_locations" {
  description = "locations in which nodes will be created"
  type        = list(string)
}
variable "remove_default_node_pool" {
  description = "Used to remove the default node pool"
  type        = bool
  default     = true
}
variable "initial_node_count" {
  description = "node count"
  type        = number
}
variable "channel" {
  description = "status of release channel"
  type        = string
  default     = "UNSPECIFIED"
}
variable "network" {
  description = "Name of the network"
  type        = string
}
variable "subnetwork" {
  description = "Name of the subnetwork"
  type        = string
}
variable "enable_shielded_nodes" {
  description = "shielded VM's to protect from attacker"
  type        = bool
  default     = "true"
}
variable "workload_pool" {
  description = "connect to Google API's"
  type        = string
  default     = "gcp-poc-nonproduction.svc.id.goog"
}
variable "issue_client_certificate" {
  description = "The authentication information for accessing the Kubernetes master"
  type        = bool
  default     = "false"
}
variable "enable_components" {
  description = "Info about the logging configs"
  type        = list(string)
  default     =  ["SYSTEM_COMPONENTS", "WORKLOADS"]
}
variable "cluster_secondary_range_name" {
    description = "The IP address range for the cluster pod IPs"
    type        = string
}
variable "services_secondary_range_name" {
    description = "The IP address range for the cluster service IPs"
    type        = string
}
variable "enable_private_endpoint" {
    description = "The cluster's private endpoint is used as the cluster endpoint"
    type        = bool
    default     = "true"
}
variable "enable_private_nodes" {
    description = "Enables the private cluster feature, creating a private endpoint on the cluster"
    type        = bool
    default     = "true"
}
variable "master_ipv4_cidr_block" {
    description = "The IP range in CIDR notation to use for the hosted master network"
    type        = string
}
variable "master_authorized_networks_config" {
  type        = list(object({ cidr_blocks = list(object({ cidr_block = string, display_name = string })) }))
  description = "The desired configuration options for master authorized networks. The object format is {cidr_blocks = list(object({cidr_block = string, display_name = string}))}. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}
# variable "cidr_block" {
#    description = "External network that can access Kubernetes master through HTTPS"
#    type        = string
#}
# variable "display_name" {
#    description = "Field for users to identify CIDR blocks"
#    type        = string
#}
variable "network_policy" {
    description = "whether network policy enabled or not"
    type       = bool
    default    = false
}
variable "master_global_access" {
  description = "whether the master cluster access globally or not "
  type        = bool
  default     = false
}
