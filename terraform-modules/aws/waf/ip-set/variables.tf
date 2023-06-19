# Define variables for the IP set

variable "ip_set_name" {
  type        = string
  description = "The name of the IP set."
}

variable "ip_set_description" {
  type        = string
  description = "A description of the IP set."
}

variable "ip_addresses" {
  type        = list(string)
  description = "A list of IP addresses in CIDR notation to include in the IP set."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the IP set."
}
