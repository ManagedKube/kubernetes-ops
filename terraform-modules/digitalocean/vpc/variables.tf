variable "vpc_name" {
    type = string
    description = "(Required) A name for the VPC. Must be unique and contain alphanumeric characters, dashes, and periods only."
}

variable "vpc_region" {
    type = string
    description = "(Required) The DigitalOcean region slug for the VPC's location."
}

variable "vpc_description" {
    type = string
    description = "(Optional) A free-form text field up to a limit of 255 characters to describe the VPC."
    default = "Your new vpc"
}
variable "vpc_ip_range" {
    type = string
    description = "(Optional) The range of IP addresses for the VPC in CIDR notation."
    default = "10.10.10.0/24"
}
variable "project_id" {
   type = string
   description = "(Optional) The id of the project where the vpc will be associated"
}