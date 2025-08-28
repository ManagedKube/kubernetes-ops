variable "project_name" {
    type = string
    description = "(Required) The name of the project"
    default = "playground"
}

variable "project_description" {
    type = string
    description = "(Optional) The name of description"
    default = "A project to represent development resources."
}

variable "project_purpose" {
    type = string
    description = "(Optional) A purpose for the project"
    default = "Web Application"
}

variable "project_environment" {
    type = string
    description = "(Optional) Kind of dev, qa or prod"
    default = "development"
}