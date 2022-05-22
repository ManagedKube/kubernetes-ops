variable "name" {
    type = string
    description = "The name of the project"
    default = "playground"
}

variable "description" {
    type = string
    description = "The name of description"
    default = "A project to represent development resources."
}

variable "purpose" {
    type = string
    description = "A purpose for the project"
    default = "Web Application"
}

variable "environment" {
    type = string
    description = "Kind of dev, qa or prod"
    default = "development"
}