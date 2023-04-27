variable "droplet_id" {
    type = string
    description = "(Required) ID of the Droplet to attach the volume to."
}

variable "volume_id" {
    type = string
    description = "(Required) ID of the Volume to be attached to the Droplet."
}

