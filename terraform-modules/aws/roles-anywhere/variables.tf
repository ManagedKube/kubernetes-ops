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
    default        = "./"
}

variable "profiles" {
    type = any
    description = "Profiles to create"
    default = {}
  
}

variable "enable_profile" {
    type           =bool
    description    ="Whether to create the profile"
    default        =true
}

variable "tags" {
  description        = "Tags to apply to all resources."
  type               = map(string)
  default            = {}
}
