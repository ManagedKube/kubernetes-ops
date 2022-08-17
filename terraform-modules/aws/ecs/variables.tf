variable "desired_count" {
    default = 3  
}

variable "launch_type" {
    type = string
    description = "Launch type"
    default = "FARGATE"
}

variable "ecs_name" {
    type = string
    description = "ecs name"  
}

variable "ordered_placement_strategy" {
    type = map
    description = "Ordered placement strategy"
    default = {
        type  = "binpack"
        field = "cpu"
  }
}