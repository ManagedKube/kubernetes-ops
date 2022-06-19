variable "droplet_name" {
    type = string
    description = "(Required) The Droplet name."
}

variable "droplet_image" {
    type = string
    description = "(Required) The Droplet image ID or slug"
}

variable "droplet_region" {
    type = string
    description = "(Required) The region to start in."
}

variable "droplet_size" {
    type = string
    description = "(Required) The unique slug that indentifies the type of Droplet. You can find a list of available slugs on DigitalOcean API documentation."
}

variable "droplet_monitoring" {
    type = bool
    description = "(Optional) Boolean controlling whether monitoring agent is installed. Defaults to false. If set to true, you can configure monitor alert policies monitor alert"
    default = false
}

variable "droplet_vpc_uuid" {
    type = string
    description = "The ID of the VPC where the Droplet will be located."
    default = null
}

variable "droplet_user_data" {
    type = string
    description = "(Optional) A string of the desired User Data for the Droplet."
}
 