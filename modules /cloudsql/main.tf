variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
  default = "asia-south1"
}

variable "org" {
  default = "pw"
}
variable "env" {}
variable "use_case" {}
variable "region_code" {
  default = "use1"
}

variable "router_name" {
  default = "pw-ops-rt-use1"
  description = "The project ID to deploy to"
}

variable "network_name" {
  type        = string
  description = "VPN name, only if router is not passed in and is created by the module."
}

variable "router_asn" {
  type        = string
  description = "Router ASN, only if router is not passed in and is created by the module."
  default     = "65412"
}

variable "router_keepalive_interval" {
  type        = string
  description = "Router keepalive_interval, only if router is not passed in and is created by the module."
  default     = "20"
}
