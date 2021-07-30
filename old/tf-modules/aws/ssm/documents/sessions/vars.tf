variable "tags" {
  type = map(string)

  default = {
    Environment = "env"
    Account     = "dev"
    Group       = "devops"
    Region      = "us-east-1"
    managed_by  = "Terraform"
  }
}

variable "document_name" {
    default = ""
}

variable "document_type" {
    default = "Session"
}

variable "document_content" {
    default = ""
}
