variable "global_network_create" {
  type        = bool
  description = "To create Global network"
}

variable "global_network_description" {
  type        = string
  description = "Description of the new Global Network to create"

}

variable "existing_global_network_id" {

    type = string
    description = "Id for the existing global network"
    default = ""
}

variable "core_network_description" {
    type = string
    description = "Core Network Description"
  
}

variable "core_network_policy_document" {
  type = string
  description = "Network policy document in jason format"
  
}

variable "transit_gateway_arn" {
  type = list(string)
  default = [ ]
  description = "TGW arn's to be registedred in Global Network"
  
}


variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
