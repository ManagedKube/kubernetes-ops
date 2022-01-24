variable "name" {
    type = string
    description = "The namespace name"
}

variable "annotations" {
  type    = map(any)
  default = {}
}

variable "labels" {
  type    = map(any)
  default = {}
}
