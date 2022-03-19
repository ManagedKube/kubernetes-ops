#namespace of the application
variable "namespace" {
  type = string
}

#name of the secret for using for reference
variable "secret_name" {
  type = string
}

#value of the json for authorize ghcr 
variable "ghcr_secret" {
  type = string
}
