
variable "volume_name" {
    type = string
    description = "(Required) A name for the block storage volume. Must be lowercase and be composed only of numbers, letters and -, up to a limit of 64 characters."
}

variable "volume_region" {
    type = string
    description = "(Required) The region that the block storage volume will be created in."
}

variable "volume_size" {
    type = number
    default = 20
    description = "(Required) The size of the block storage volume in GiB. If updated, can only be expanded."
}

variable "volume_initial_filesystem_type" {
    type = string
    description = "(Optional) Initial filesystem type (xfs or ext4) for the block storage volume."
}

variable "volume_description" {
    type = string
    description = "(Optional) A free-form text field up to a limit of 1024 bytes to describe a block storage volume.."
}

