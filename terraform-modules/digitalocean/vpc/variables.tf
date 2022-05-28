variable "vpc_name" {
    type = string
    description = " A name for the VPC. Must be unique and contain alphanumeric characters, dashes, and periods only."
}

variable "vpc_region" {
    type = string
    description = "The DigitalOcean region slug for the VPC's location."
}

variable "vpc_description" {
    type = string
    description = "A free-form text field up to a limit of 255 characters to describe the VPC."
    default = "Your new vpc"
}
variable "vpc_ip_range" {
    type = string
    description = "The range of IP addresses for the VPC in CIDR notation."
    default = "10.10.10.0/24"
}
variable "vpc_project_id" {
   type = string
   description = "The id of the project where the vpc will be associated"
}