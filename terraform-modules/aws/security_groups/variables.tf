variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "security_groups" {
  # type = any
  type = list(object({
    name = string,
    config = list(object({
      enabled          = bool,
      sg_type          = string,
      allow_group_name = string,
      group_type       = string,
      from_port        = string,
      to_port          = string,
      protocol         = string,
      cidr_blocks      = list(string),
      description      = string,
    })),
    tags = map(any),
  }))

  description = "Security groups grouping config"

  # default = [
  #   {
  #     name = "group-name",
  #     config = [
  #       {
  #         enabled                = true,
  #         sg_type                = "ingress",
  #         allow_group_name       = "node2",
  #         group_type             = "internal_mapping"
  #         from_port              = "1234",
  #         to_port                = "1234"
  #         protocol               = "tcp",
  #         cidr_blocks            = [],
  #         description            = "Allowing node2 on port 1234"
  #       },
  #       {
  #         enabled                = true,
  #         sg_type                = "ingress",
  #         allow_group_name       = "node2",
  #         group_type             = "internal_mapping"
  #         from_port              = "1234",
  #         to_port                = "1234"
  #         protocol               = "tcp",
  #         cidr_blocks            = [],
  #         description            = "Allowing node2 on port 1234"
  #       },
  #       {
  #         enabled                = true,
  #         sg_type                = "ingress",
  #         allow_group_name       = "null",
  #         group_type             = "cidr_blocks"
  #         from_port              = "-1",
  #         to_port                = "-1"
  #         protocol               = "tcp",
  #         cidr_blocks            = ["0.0.0.0/0"],
  #         description            = "Allowing cidr block"
  #       },
  #       {
  #         enabled                = true,
  #         sg_type                = "ingress",
  #         allow_group_name       = "sg-xxxxxx",
  #         group_type             = "external_sg"
  #         from_port              = "-1",
  #         to_port                = "-1"
  #         protocol               = "-1",
  #         cidr_blocks            = [],
  #         description            = "Allowing an externally created sg group"
  #       },
  #     ],
  #     tags = {}
  #   }
  # ],
}
