variable "direction" {
  description = "type of direction"
  type        = string
}
variable "network" {
  description = "Name of the network"
  type        = string
}
variable "priority" {
    description = "firewall rule priority"
    type        = number
}
variable "project" {
    description = "Name of the project"
    type        = string
}
variable "port" {
  description = "list of ports to which this rule applies"
  type        = list(string) 
}
variable "protocol" {
  description = "IP protocol to which this rule applies"
  type        = string
}
variable "description" {
  description = "Description of the firewall "
  type        = string
}
variable "name" {
  description = "Name of the firewall"
  type        = string
}
variable "source_ranges" {
  description = "Source IP ranges"
}
variable "target_tags" {
  description = "target tag"
  type        = list(string)
}
