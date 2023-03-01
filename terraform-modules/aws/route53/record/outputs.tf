variable "name" {
  description = "The name for the Route 53 record."
  type        = string
}

variable "fqdn" {
  description = "FQDN built using the zone domain and name."
  type        = string
}