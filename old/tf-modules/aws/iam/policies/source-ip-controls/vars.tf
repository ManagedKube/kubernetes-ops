variable "name" {
  default = "source-ip-control"
}

variable "description" {
  default = "Controls the source IP allowed to access the AWS API.  Managed by Terraform."
}

variable "path" {
  default = "/"
}

variable "source-ip-list" {
  type = list
  default = []
}
