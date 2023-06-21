variable "enable_trust_anchor" {
    type          = bool
    description   = "Whether to create the trust anchor"
    default       =false
}

variable "trust_anchor_name" {
    type           = string
    description    = "Name of the trust anchor"
    default        = ""
}

variable "cert_bundle" {
    type           = string
    description    = "Path to the certificate bundle document"
    default        = ""
}

variable "enable_profile" {
    type           =bool
    description    ="Whether to create the profile"
    default        =false
}

variable "profile_name" {
    type           = string
    description    = "Name of the profile you want to create"
    default        = ""
}

variable "role_arns" {
    type            = list(string)
    description     = "Role ARN's to be used for the roles-anywhere profile "
    default         = []
}

variable "tags" {
  description        = "Tags to apply to all resources."
  type               = map(string)
  default            = {}
}
